import 'dart:math';

class Coupon {
  String id;
  String couponKey;
  String discount;
  String maxBillingAmount;
  String uid;
  String createAt;
  String expiredDate;
  Coupon(
      {this.id,
      this.couponKey,
      this.discount,
      this.maxBillingAmount,
      this.uid,
      this.expiredDate,
      this.createAt});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'coupon_key': couponKey,
      'discount': discount,
      'max_billing_amount': maxBillingAmount,
      'create_at': createAt,
      'expired_date': expiredDate
    };
  }

  //TODO get random coupon key
  static String randomCouponKey(int length) {
    var random = new Random();
    var keyUnits =
        new List.generate(length, (index) => random.nextInt(33) + 89);
    return new String.fromCharCodes(keyUnits);
  }
}
