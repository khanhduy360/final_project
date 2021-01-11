import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_dgreen/link.dart';
import 'package:flutter_dgreen/src/component/search_address_view.dart';
import 'package:flutter_dgreen/src/component/textline_between.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/coupon.dart';
import 'package:flutter_dgreen/src/model/product.dart';
import 'package:flutter_dgreen/src/services/stripe_payment.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/CartPage/payment_complete_view.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/card_product_order.dart';
import 'package:flutter_dgreen/src/widgets/category_item.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'checkout_controller.dart';

class ProcessingOrderView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();
  ProcessingOrderView({this.productList, this.total, this.uid});
  final int total;
  final List<Product> productList;
  final String uid;

  @override
  _ProcessingOrderViewState createState() => _ProcessingOrderViewState();
}

class _ProcessingOrderViewState extends State<ProcessingOrderView> {
  CheckoutController _checkoutController = new CheckoutController();
  String _receiverName = '';
  String _phoneNumber = '';
  String _address = '';
  String cardNumber = '';
  int expiryMonth;
  int expiryYear;
  String cardHolderName = '';
  String cvvCode = '';
  Coupon coupon = new Coupon();
  double discountPrice = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: kColorGreen),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Thanh Toán',
          style: TextStyle(
              color: kColorGreen,
              fontSize: FontSize.setTextSize(32),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
              top: ConstScreen.setSizeHeight(30),
              bottom: ConstScreen.setSizeHeight(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: Shipping info
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: ConstScreen.setSizeHeight(30),
                        bottom: ConstScreen.setSizeHeight(20),
                        left: ConstScreen.setSizeHeight(40),
                        right: ConstScreen.setSizeHeight(40)),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: kColorRed,
                                size: ConstScreen.setSizeHeight(40),
                              ),
                              AutoSizeText('Thông tin vận chuyển:',
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  minFontSize: 15,
                                  style: TextStyle(
                                      fontSize: FontSize.setTextSize(34),
                                      color: kColorBlack,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(20),
                        ),
                        //TODO: Name
                        StreamBuilder(
                          stream: _checkoutController.nameStream,
                          builder: (context, snapshot) {
                            return InputText(
                              title: 'Tên người nhận',
                              errorText:
                                  snapshot.hasError ? snapshot.error : '',
                              inputType: TextInputType.text,
                              onValueChange: (name) {
                                _receiverName = name;
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(20),
                        ),
                        //TODO: Phone number
                        StreamBuilder(
                          stream: _checkoutController.phoneStream,
                          builder: (context, snapshot) {
                            return InputText(
                              title: 'Số điện thoại',
                              errorText:
                                  snapshot.hasError ? snapshot.error : '',
                              inputType: TextInputType.number,
                              onValueChange: (phoneNumber) {
                                _phoneNumber = phoneNumber;
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(20),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: kColorRed,
                                size: ConstScreen.setSizeHeight(40),
                              ),
                              AutoSizeText('Địa chỉ:',
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  minFontSize: 15,
                                  style: TextStyle(
                                      fontSize: FontSize.setTextSize(34),
                                      color: kColorBlack,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(20),
                        ),
                        // TODO: get Address
                        GestureDetector(
                          onTap: () async {
                            Prediction p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey:
                                    'AIzaSyBHwSceZWVDO_3B9WyycSlWKJ3adYeHI48', // Mode.fullscreen
                                mode: Mode.fullscreen,
                                language: "vn",
                                components: [
                                  new Component(Component.country, "vn")
                                ]);
                            if (p.description != null) {
                              setState(() {
                                _address = p.description;
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  color: kColorBlack.withOpacity(0.3)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: ConstScreen.setSizeHeight(20),
                                  bottom: ConstScreen.setSizeHeight(20),
                                  left: ConstScreen.setSizeHeight(20),
                                  right: ConstScreen.setSizeHeight(20)),
                              child: Text(_address,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: FontSize.setTextSize(30),
                                      color: kColorGreen,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                        ),
                        //TODO: Error address check
                        // StreamBuilder(
                        //   stream: _checkoutController.addressStream,
                        //   builder: (context, snapshot) {
                        //     return InputText(
                        //       title: 'Địa chỉ',
                        //       errorText:
                        //           snapshot.hasError ? snapshot.error : '',
                        //       onValueChange: (address) {
                        //         _address = address;
                        //       },
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                //TODO: Coupon
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: ConstScreen.setSizeHeight(30),
                        bottom: ConstScreen.setSizeHeight(20),
                        left: ConstScreen.setSizeHeight(40),
                        right: ConstScreen.setSizeHeight(40)),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.ticketAlt,
                                size: ConstScreen.setSizeHeight(35),
                                color: kColorOrange,
                              ),
                              SizedBox(
                                width: ConstScreen.setSizeWidth(12),
                              ),
                              AutoSizeText(
                                'Mã giảm giá:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: FontSize.setTextSize(34),
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeWidth(20),
                        ),
                        //TODO: Coupon key
                        Column(
                          children: <Widget>[
                            (coupon.discount != null && coupon.discount != '')
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          ('Giảm giá : ${coupon.discount}%'),
                                          style: kNormalTextStyle.copyWith(
                                              fontSize: FontSize.s30),
                                        ),
                                        Text(
                                          ('Khoảng tiền thanh toán: ${Util.intToMoneyType(int.parse(coupon.maxBillingAmount))}'),
                                          style: kNormalTextStyle.copyWith(
                                              fontSize: FontSize.s30),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: ConstScreen.setSizeHeight(15),
                            ),
                            //TODO: Coupon Dialog
                            CusRaisedButton(
                              title: 'Lấy mã',
                              backgroundColor: kColorGreen,
                              onPress: () {
                                List<CategoryItem> privateCoupon = [];
                                List<CategoryItem> globalCoupon = [];
                                showDialog(
                                    context: context,
                                    child: Dialog(
                                      backgroundColor: kColorWhite,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Container(
                                        height: ConstScreen.setSizeHeight(600),
                                        child: Column(
                                          children: <Widget>[
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ConstScreen
                                                        .setSizeHeight(20)),
                                                child: Text(
                                                  'Mã giảm giá',
                                                  style:
                                                      kBoldTextStyle.copyWith(
                                                          fontSize:
                                                              FontSize.s36),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  //TODO: your coupon
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Coupon')
                                                          .where('uid',
                                                              isEqualTo:
                                                                  widget.uid)
                                                          .orderBy('create_at')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          for (var document
                                                              in snapshot
                                                                  .data.docs) {
                                                            if (Util.isDateGreaterThanNow(
                                                                document[
                                                                    'expired_date'])) {
                                                              privateCoupon.add(
                                                                  CategoryItem(
                                                                title:
                                                                    'Giảm: ${document['discount']}% \nGiá trị hóa đơn: ${Util.intToMoneyType(int.parse(document['max_billing_amount']))} VND \nNgày hết hạn: ${Util.convertDateToString(document['expired_date'].toString())}',
                                                                onTap: () {
                                                                  Coupon coup = new Coupon(
                                                                      id: document
                                                                          .id,
                                                                      discount:
                                                                          document[
                                                                              'discount'],
                                                                      maxBillingAmount:
                                                                          document[
                                                                              'max_billing_amount']);

                                                                  setState(() {
                                                                    coupon =
                                                                        coup;
                                                                  });

                                                                  discountPrice = widget
                                                                          .total *
                                                                      (double.parse(
                                                                              coupon.discount) /
                                                                          100);
                                                                  if (discountPrice >
                                                                      double.parse(
                                                                          coupon
                                                                              .maxBillingAmount)) {
                                                                    discountPrice =
                                                                        double.parse(
                                                                            coupon.maxBillingAmount);
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                height: 150,
                                                              ));
                                                            }
                                                          }
                                                          return ExpansionTile(
                                                            title: Text(
                                                              'Mã giảm giá của bạn',
                                                              style: TextStyle(
                                                                  fontSize: FontSize
                                                                      .setTextSize(
                                                                          32),
                                                                  color:
                                                                      kColorBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            children: snapshot
                                                                    .hasData
                                                                ? privateCoupon
                                                                : [],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                  //TODO: global coupon
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Coupon')
                                                          .where('uid',
                                                              isEqualTo:
                                                                  'global')
                                                          .orderBy('create_at')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          for (var document
                                                              in snapshot
                                                                  .data.docs) {
                                                            if (Util.isDateGreaterThanNow(
                                                                document[
                                                                    'expired_date'])) {
                                                              globalCoupon.add(
                                                                  CategoryItem(
                                                                title:
                                                                    'Giảm: ${document['discount']}% \nGiá trị hóa đơn: ${Util.intToMoneyType(int.parse(document['max_billing_amount']))} VND \nNgày hết hạn: ${Util.convertDateToString(document['expired_date'].toString())}',
                                                                onTap: () {
                                                                  Coupon coup = new Coupon(
                                                                      id: document
                                                                          .id,
                                                                      discount:
                                                                          document[
                                                                              'discount'],
                                                                      maxBillingAmount:
                                                                          document[
                                                                              'max_billing_amount']);

                                                                  setState(() {
                                                                    coupon =
                                                                        coup;
                                                                  });

                                                                  discountPrice = widget
                                                                          .total *
                                                                      (double.parse(
                                                                              coupon.discount) /
                                                                          100);
                                                                  if (discountPrice >
                                                                      double.parse(
                                                                          coupon
                                                                              .maxBillingAmount)) {
                                                                    discountPrice =
                                                                        double.parse(
                                                                            coupon.maxBillingAmount);
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                height: 150,
                                                              ));
                                                            }
                                                          }
                                                          return ExpansionTile(
                                                            title: Text(
                                                              'Mã giảm giá dùng chung',
                                                              style: TextStyle(
                                                                  fontSize: FontSize
                                                                      .setTextSize(
                                                                          32),
                                                                  color:
                                                                      kColorBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                            children: (snapshot
                                                                    .hasData)
                                                                ? globalCoupon
                                                                : [],
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Your Order
                Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: ConstScreen.setSizeHeight(30),
                        bottom: ConstScreen.setSizeHeight(20),
                        left: ConstScreen.setSizeHeight(40),
                        right: ConstScreen.setSizeHeight(40)),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.list,
                                size: ConstScreen.setSizeHeight(40),
                              ),
                              SizedBox(
                                width: ConstScreen.setSizeWidth(5),
                              ),
                              AutoSizeText(
                                'Đơn hàng của bạn:',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: FontSize.setTextSize(34),
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeWidth(20),
                        ),
                        //TODO: list order item
                        Column(
                          children: widget.productList.map((product) {
                            return ProductOrderDetail(
                              name: product.productName,
                              price: (product.salePrice == '0')
                                  ? product.price
                                  : product.salePrice,
                              quantity: product.quantity,
                              color: Color(product.color),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeWidth(20),
                        ),
                        //TODO: Sub total
                        TextLineBetween(
                            label: 'Giá sản phẩm: ',
                            content: Util.intToMoneyType(widget.total) + ' VND',
                            contentStyle: TextStyle(
                                color: kColorGreen,
                                fontFamily: kFontMontserratBold,
                                fontSize: 16)),
                        TextLineBetween(
                            label: 'Phí vận chuyển: ',
                            content: (widget.total > 300000)
                                ? '+0 VND'
                                : '+20,000 VND',
                            contentStyle: TextStyle(
                                color: kColorGreen,
                                fontFamily: kFontMontserratBold,
                                fontSize: 16)),

                        //TODO: coupon
                        (coupon.discount != null && coupon.discount != '')
                            ? TextLineBetween(
                                label: 'Giảm giá: ',
                                content: coupon.discount +
                                    '%\n-${Util.intToMoneyType(discountPrice.toInt())} VND',
                                contentStyle: TextStyle(
                                    color: kColorGreen,
                                    fontFamily: kFontMontserratBold,
                                    fontSize: 16))
                            : Container(),

                        //TODO: TOTAL
                        TextLineBetween(
                            label: 'Tổng cộng: ',
                            content: Util.intToMoneyType((widget.total > 300000)
                                    ? widget.total - discountPrice.floor()
                                    : widget.total +
                                        20000 -
                                        discountPrice.floor()) +
                                ' VND',
                            contentStyle: TextStyle(
                                color: kColorGreen,
                                fontFamily: kFontMontserratBold,
                                fontSize: 16)),

                        //TODO: Error quantity check
                        StreamBuilder(
                          stream: _checkoutController.quantityStream,
                          builder: (context, snapshot) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: ConstScreen.setSizeHeight(10),
                                  left: ConstScreen.setSizeHeight(22),
                                ),
                                child: AutoSizeText(
                                    snapshot.hasError ? snapshot.error : '',
                                    textAlign: TextAlign.start,
                                    maxLines: 20,
                                    minFontSize: 12,
                                    style: TextStyle(
                                        fontSize: FontSize.setTextSize(20),
                                        color: snapshot.hasError
                                            ? kColorRed
                                            : kColorBlack,
                                        fontWeight: FontWeight.normal)),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: StreamBuilder(
            stream: _checkoutController.btnLoadingStream,
            builder: (context, snapshot) {
              return CusRaisedButton(
                title: 'THANH TOÁN',
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                height: ConstScreen.setSizeHeight(150),
                backgroundColor: kColorGreen,
                onPress: () async {
                  bool isValidate = await _checkoutController.onValidate(
                    name: _receiverName,
                    phoneNumber: _phoneNumber,
                    address: _address,
                    productList: widget.productList,
                    total: Util.intToMoneyType((widget.total > 300000)
                        ? widget.total - discountPrice.floor()
                        : widget.total + 20000 - discountPrice.floor()),
                  );

                  if (isValidate) {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: ConstScreen.setSizeHeight(30),
                                  bottom: ConstScreen.setSizeHeight(20),
                                  left: ConstScreen.setSizeHeight(40),
                                  right: ConstScreen.setSizeHeight(40)),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.payment,
                                          size: ConstScreen.setSizeHeight(40),
                                        ),
                                        SizedBox(
                                          width: ConstScreen.setSizeWidth(5),
                                        ),
                                        AutoSizeText(
                                          'Chọn hình thức:',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          minFontSize: 15,
                                          style: TextStyle(
                                              fontSize:
                                                  FontSize.setTextSize(34),
                                              color: kColorBlack,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ConstScreen.setSizeWidth(20),
                                  ),
                                  //TODO: Pay via new card
                                  CusRaisedButton(
                                    title: 'Trả với thẻ mới',
                                    backgroundColor: kColorGreen,
                                    onPress: () async {
                                      String orderId = DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString();
                                      var response = await StripeService
                                          .paymentWithNewCard(
                                              amount: ((widget.total > 300000)
                                                      ? widget.total -
                                                          discountPrice.floor()
                                                      : widget.total +
                                                          20000 -
                                                          discountPrice.floor())
                                                  .toString(),
                                              currency: 'VND',
                                              orderId: orderId);
                                      // TODO: Create Order
                                      if (response.success) {
                                        _checkoutController.onPayment(
                                            name: _receiverName,
                                            phoneNumber: _phoneNumber,
                                            address: _address,
                                            productList: widget.productList,
                                            total: ((widget.total > 300000)
                                                    ? widget.total -
                                                        discountPrice.floor()
                                                    : widget.total +
                                                        20000 -
                                                        discountPrice.floor())
                                                .toString(),
                                            clientSecret: response.clientSecret,
                                            orderId: orderId,
                                            paymentMethodId:
                                                response.paymentMethodId,
                                            discountPrice: discountPrice
                                                .floor()
                                                .toString(),
                                            coupon: coupon);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentCompleteView(
                                                      totalPrice:
                                                          (widget.total >
                                                                  300000)
                                                              ? widget.total -
                                                                  discountPrice
                                                                      .floor()
                                                              : widget.total +
                                                                  20000 -
                                                                  discountPrice
                                                                      .floor(),
                                                    )));
                                      } else {
                                        Navigator.pop(context);
                                        widget._globalKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(response.clientSecret),
                                          duration: Duration(seconds: 10),
                                        ));
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: ConstScreen.setSizeWidth(15),
                                  ),
                                  //TODO: Payment via existing card
                                  CusRaisedButton(
                                    title: 'Dùng thẻ hiện tại',
                                    backgroundColor: kColorGreen,
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('Cards')
                                                      .where('uid',
                                                          isEqualTo: widget.uid)
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Column(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            height: ConstScreen
                                                                .setSizeHeight(
                                                                    15),
                                                          ),
                                                          AutoSizeText(
                                                            'Thẻ ngân hàng',
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            minFontSize: 15,
                                                            style: TextStyle(
                                                                fontSize: FontSize
                                                                    .setTextSize(
                                                                        34),
                                                                color:
                                                                    kColorBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            height: ConstScreen
                                                                .setSizeHeight(
                                                                    15),
                                                          ),
                                                          (snapshot.data.docs
                                                                      .length !=
                                                                  0)
                                                              ? ListView(
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  children: snapshot
                                                                      .data.docs
                                                                      .map((DocumentSnapshot
                                                                          document) {
                                                                    return Center(
                                                                      child:
                                                                          GestureDetector(
                                                                        //TODO: Payment with exist card
                                                                        onTap:
                                                                            () async {
                                                                          ProgressDialog
                                                                              dialog =
                                                                              new ProgressDialog(context);
                                                                          dialog.style(
                                                                              message: 'Vui lòng chờ...');
                                                                          dialog
                                                                              .show();
                                                                          //TODO: Show dialog loading
                                                                          cardNumber =
                                                                              document['cardNumber'];
                                                                          expiryMonth =
                                                                              document['expiryMonth'];
                                                                          expiryYear =
                                                                              document['expiryYear'];
                                                                          cardHolderName =
                                                                              document['cardHolderName'];
                                                                          cvvCode =
                                                                              document['cvvCode'];
                                                                          CreditCard
                                                                              stripeCard =
                                                                              CreditCard(
                                                                            number:
                                                                                cardNumber,
                                                                            expMonth:
                                                                                expiryMonth,
                                                                            expYear:
                                                                                expiryYear,
                                                                          );
                                                                          String
                                                                              orderId =
                                                                              DateTime.now().millisecondsSinceEpoch.toString();
                                                                          var response = await StripeService.paymentWithExistCard(
                                                                              amount: (((widget.total >= 300000) ? 0 : 20000) + widget.total - discountPrice.floor()).toString(),
                                                                              currency: 'VND',
                                                                              card: stripeCard,
                                                                              orderId: orderId);
                                                                          dialog
                                                                              .hide();
                                                                          // TODO: Create Order
                                                                          if (response
                                                                              .success) {
                                                                            _checkoutController.onPayment(
                                                                                name: _receiverName,
                                                                                phoneNumber: _phoneNumber,
                                                                                address: _address,
                                                                                productList: widget.productList,
                                                                                total: (((widget.total >= 300000) ? 0 : 20000) + widget.total - discountPrice.floor()).toString(),
                                                                                orderId: orderId,
                                                                                clientSecret: response.clientSecret,
                                                                                paymentMethodId: response.paymentMethodId,
                                                                                discountPrice: discountPrice.floor().toString(),
                                                                                coupon: coupon);
                                                                            //TODO: Payment success
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => PaymentCompleteView(
                                                                                          totalPrice: (widget.total > 300000) ? widget.total - discountPrice.floor() : widget.total + 20000 - discountPrice.floor(),
                                                                                        )));
                                                                          } else {
                                                                            Navigator.pop(context);
                                                                            Navigator.pop(context);
                                                                            widget._globalKey.currentState.showSnackBar(SnackBar(
                                                                              content: Text(response.clientSecret),
                                                                              duration: Duration(seconds: 10),
                                                                            ));
                                                                          }
                                                                        },
                                                                        child:
                                                                            CreditCardWidget(
                                                                          height:
                                                                              ConstScreen.setSizeHeight(340),
                                                                          width:
                                                                              ConstScreen.setSizeWidth(520),
                                                                          textStyle: TextStyle(
                                                                              fontSize: FontSize.setTextSize(34),
                                                                              color: kColorWhite,
                                                                              fontWeight: FontWeight.bold),
                                                                          cardNumber:
                                                                              document['cardNumber'],
                                                                          expiryDate:
                                                                              '${document['expiryMonth'].toString()} / ${document['expiryYear'].toString()}',
                                                                          cardHolderName:
                                                                              document['cardHolderName'],
                                                                          cvvCode:
                                                                              document['cvvCode'],
                                                                          showBackView:
                                                                              false,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                )
                                                              : Container(
                                                                  height: ConstScreen
                                                                      .setSizeHeight(
                                                                          800),
                                                                  width: ConstScreen
                                                                      .setSizeWidth(
                                                                          520),
                                                                  child: Stack(
                                                                    children: <
                                                                        Widget>[
                                                                      Positioned(
                                                                        top: ConstScreen.setSizeWidth(
                                                                            350),
                                                                        left: ConstScreen.setSizeHeight(
                                                                            120),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              ConstScreen.setSizeWidth(324),
                                                                          height:
                                                                              ConstScreen.setSizeHeight(170),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
                                                                              image: AssetImage(KImageAddress + 'noCreditCard.png'),
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: ConstScreen.setSizeHeight(
                                                                            650),
                                                                        left: ConstScreen.setSizeWidth(
                                                                            100),
                                                                        child:
                                                                            Text(
                                                                          'Không tìm thấy thẻ',
                                                                          style: kBoldTextStyle.copyWith(
                                                                              color: kColorBlack.withOpacity(0.8),
                                                                              fontSize: FontSize.s36,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                              ));
                                    },
                                  ),
                                  SizedBox(
                                    height: ConstScreen.setSizeWidth(15),
                                  ),
                                  CusRaisedButton(
                                    title: 'Hủy',
                                    backgroundColor: kColorRed,
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              );
            }),
      ),
    );
  }
}
