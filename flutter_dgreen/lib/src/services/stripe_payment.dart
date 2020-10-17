import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeTransactionResponse {
  String clientSecret;
  String paymentMethodId;
  bool success;
  StripeTransactionResponse(
      {this.clientSecret, this.success, this.paymentMethodId});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  //TODO: my Stripe api secret
  static String secret =
      'sk_test_51HcuIrJxZzpj0DkQCezvfOGUuvBzN2u4LMDtNt16wxMMkyp9DNIwI4Vxh0hee4bbkW46jNjZm55d5VHMGh8KFwKB00S706Xv8y';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static Map<String, String> header = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51HcuIrJxZzpj0DkQugwge2WEDB4ZCCutbbfdaUcM1JDZnl4gud4D5VUovJHrHxZzcz2uR50HF6VDO5FvY8El05s900r6C3a9Dk",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  //TODO: Payment via exist Card
  static Future<StripeTransactionResponse> paymentWithExistCard(
      {String amount, String currency, CreditCard card, String orderId}) async {
    try {
      //TODO: step1: Create payment method
      var paymentMethod = await StripePayment.createPaymentMethod(
          PaymentMethodRequest(card: card));
      //TODO: step2: Create payment intent
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      //TODO: Save clientSecret and paymentMethodId
      return new StripeTransactionResponse(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
          success: true);
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          clientSecret: 'Transaction failed: ${err.toString()}',
          success: false);
    }
  }

  //TODO: Payment via New Card
  static Future<StripeTransactionResponse> paymentWithNewCard(
      {String amount, String currency, String orderId}) async {
    try {
      //TODO: step1: Create a payment method
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      //TODO: step2: Create a payment intent
      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);
      //TODO: Save clientSecret and paymentMethodId

      return new StripeTransactionResponse(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
          success: true);
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          clientSecret: 'Transaction failed: ${err.toString()}',
          success: false);
    }
  }

  //TODO: Create payment intent
  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.header);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

//TODO: confirm payment
  static confirmPaymentIntent({
    String clientSecret,
    String paymentMethodId,
  }) async {
    try {
      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: clientSecret, paymentMethodId: paymentMethodId));
      if (response.status == 'succeeded') {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return false;
  }

  //TODO: catch error
  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(clientSecret: message, success: false);
  }

  //TODO: get currency rate
  static Future<double> getCurrencyRate() async {
    http.Response response = await http.get(
        'https://free.currconv.com/api/v7/convert?q=VND_USD&compact=ultra&apiKey=c0c3e3341e8567bfa2e6');
    return jsonDecode(response.body)['VND_USD'];
  }
}
