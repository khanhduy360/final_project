import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dgreen/src/component/textline_between.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/coupon.dart';
import 'package:flutter_dgreen/src/views/HomePage/Admin/Users/admin_coupon_controller.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/category_item.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GlobalCouponView extends StatefulWidget {
  @override
  _GlobalCouponViewState createState() => _GlobalCouponViewState();
}

class _GlobalCouponViewState extends State<GlobalCouponView> {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Coupon')
            .where('uid', isEqualTo: 'global')
            .orderBy('create_at')
            .snapshots(),
        builder: (context, snapshot) {
          int index = 0;
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Xóa',
                      color: kColorRed,
                      icon: Icons.delete,
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('Coupon')
                            .doc(document.id)
                            .delete();
                        setState(() {});
                      },
                    ),
                  ],
                  child: Card(
                    child: CategoryItem(
                      title:
                          'ID: \t\t${++index}\nGiảm giá: ${document['discount']}% \nGiá trị hóa đơn: ${Util.intToMoneyType(int.parse(document['max_billing_amount']))} VND\nNgày tạo: ${Util.convertDateToString(document['create_at'].toString())} \nNgày hết hạn: ${Util.convertDateToString(document['expired_date'].toString())}',
                      height: 250,
                      onTap: () {},
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kColorGreen,
        child: Icon(
          Icons.add,
          color: kColorWhite,
          size: ConstScreen.setSizeHeight(50),
        ),
        onPressed: () {
          Coupon coupon = new Coupon();
          DateTime expiredDate;
          CouponController couponController = new CouponController();
          TextEditingController discountTextController =
              new TextEditingController();
          TextEditingController billingAmountTextController =
              new TextEditingController();
          //TODO: sent Coupon
          showDialog(
              context: context,
              child: Dialog(
                child: Container(
                  height: ConstScreen.setSizeHeight(620),
                  child: Padding(
                    padding: EdgeInsets.all(ConstScreen.setSizeHeight(10)),
                    child: Column(
                      children: <Widget>[
                        //TODO: Tittle
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ConstScreen.setSizeHeight(25)),
                          child: Text(
                            'Mã khuyến mãi',
                            style: kBoldTextStyle.copyWith(
                                fontSize: FontSize.setTextSize(45)),
                          ),
                        ),
                        //TODO: Discount
                        StreamBuilder(
                            stream: couponController.discountStream,
                            builder: (context, snapshot) {
                              return InputText(
                                title: 'Giảm giá',
                                controller: discountTextController,
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                inputType: TextInputType.number,
                                hintText: '50%',
                              );
                            }),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(15),
                        ),
                        //TODO: Max discount price
                        StreamBuilder(
                            stream: couponController.billingAmountStream,
                            builder: (context, snapshot) {
                              return InputText(
                                title: 'Giá trị hóa đơn',
                                controller: billingAmountTextController,
                                errorText:
                                    snapshot.hasError ? snapshot.error : null,
                                inputType: TextInputType.number,
                                hintText: '100,000',
                              );
                            }),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(30),
                        ),
                        //TODO: Date time picker
                        FlatButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                theme: DatePickerTheme(
                                  headerColor: kColorGreen,
                                  doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                minTime: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day),
                                maxTime:
                                    DateTime(DateTime.now().year + 50, 12, 31),
                                onChanged: (date) {
                              expiredDate = date;
                            }, onConfirm: (date) {
                              expiredDate = date;
                              coupon.expiredDate = date.toString();
                              couponController.expiredDateSink.add(true);
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.vi);
                          },
                          child: Container(
                            height: ConstScreen.setSizeHeight(100),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                    color: kColorBlack.withOpacity(0.7))),
                            child: Center(
                              child: StreamBuilder(
                                  stream: couponController.expiredDateStream,
                                  builder: (context, snapshot) {
                                    return snapshot.hasError
                                        ? Text(
                                            snapshot.error,
                                            style: TextStyle(
                                                color: kColorRed,
                                                fontSize: FontSize.s30,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Text(
                                            snapshot.hasData
                                                ? ('Ngày hết hạn: ' +
                                                    expiredDate.day.toString() +
                                                    '/' +
                                                    expiredDate.month
                                                        .toString() +
                                                    '/' +
                                                    expiredDate.year.toString())
                                                : 'Chọn ngày hết hạn',
                                            style: TextStyle(
                                                color: kColorGreen,
                                                fontSize: FontSize.s30,
                                                fontWeight: FontWeight.w400),
                                          );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(30),
                        ),
                        //TODO: button
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: CusRaisedButton(
                                title: 'Tạo',
                                backgroundColor: kColorGreen,
                                onPress: () {
                                  coupon.discount = discountTextController.text;

                                  coupon.maxBillingAmount =
                                      billingAmountTextController.text;
                                  coupon.uid = 'global';
                                  coupon.couponKey = Coupon.randomCouponKey(10);
                                  coupon.createAt = DateTime.now().toString();
                                  var result =
                                      couponController.onCreateCoupon(coupon);
                                  if (result == 0) {
                                    Navigator.pop(context);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: ConstScreen.setSizeHeight(20),
                            ),
                            Expanded(
                              flex: 1,
                              child: CusRaisedButton(
                                title: 'Hủy',
                                backgroundColor: kColorLightGrey,
                                onPress: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
