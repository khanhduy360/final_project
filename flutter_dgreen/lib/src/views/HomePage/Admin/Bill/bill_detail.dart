import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/orderInfo.dart';
import 'package:flutter_dgreen/src/model/quantityOrder.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_info_view.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/card_order.dart';

class BillDetail extends StatefulWidget {
  BillDetail({this.status, this.isAdmin});
  final String status;
  final bool isAdmin;
  @override
  _BillDetailState createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  StreamController _controller = new StreamController();
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      this.uid = uid;
      _controller.sink.add(true);
    });
  }

  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ConstScreen.setSizeWidth(20),
              vertical: ConstScreen.setSizeHeight(20)),
          child: StreamBuilder(
            stream: _controller.stream,
            builder: (context, mainSnapshot) {
              if (mainSnapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where('status', isEqualTo: widget.status)
                        .orderBy('create_at')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (mainSnapshot.hasData && snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                                OrderInfo orderInfo = new OrderInfo(
                                    id: document['id'],
                                    subId: document['sub_Id'],
                                    customerName: document['customer_name'],
                                    receiverName: document['receiver_name'],
                                    address: document['address'],
                                    phone: document['phone'],
                                    status: document['status'],
                                    total: document['total'],
                                    createAt: Util.convertDateToFullString(
                                        document['create_at']),
                                    shipping: document['shipping'],
                                    discount: document['discount'],
                                    discountPrice: document['discountPrice'],
                                    maxBillingAmount:
                                        document['billingAmount']);
                                return OrderCard(
                                  id: document['sub_Id'],
                                  date: Util.convertDateToFullString(
                                      document['create_at']),
                                  customerName: document['customer_name'],
                                  admin: document['admin'],
                                  status: document['status'],
                                  total: Util.intToMoneyType(
                                      int.parse(document['total'])),
                                  isEnableCancel:
                                      (document['status'] != 'Canceled' &&
                                          document['status'] != 'Completed'),
                                  onViewDetail: () {
                                    bool isCancelled =
                                        document['status'] == 'Canceled';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderInfoView(
                                                  orderInfo: orderInfo,
                                                  id: document['sub_Id'],
                                                  descriptionCancel: isCancelled
                                                      ? document['description']
                                                      : ' ',
                                                )));
                                  },
                                  onCancel: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          String description = '';
                                          return Dialog(
                                            child: Container(
                                              height: ConstScreen.setSizeHeight(
                                                  700),
                                              width:
                                                  ConstScreen.setSizeWidth(600),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ConstScreen
                                                        .setSizeHeight(20),
                                                    horizontal: ConstScreen
                                                        .setSizeWidth(15)),
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Center(
                                                        child: Text(
                                                          'Hủy',
                                                          style: kBoldTextStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      FontSize
                                                                          .s36),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: ConstScreen
                                                          .setSizeHeight(20),
                                                    ),
                                                    //TODO: description
                                                    Expanded(
                                                      flex: 5,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: TextField(
                                                          decoration: InputDecoration(
                                                              hintStyle: kBoldTextStyle
                                                                  .copyWith(
                                                                      fontSize: FontSize
                                                                          .s25),
                                                              hintText:
                                                                  'Mô tả',
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelStyle: kBoldTextStyle
                                                                  .copyWith(
                                                                      fontSize:
                                                                          FontSize
                                                                              .s30)),
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          onChanged: (value) {
                                                            description = value;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: ConstScreen
                                                          .setSizeHeight(20),
                                                    ),
                                                    //TODO: Button
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        children: <Widget>[
                                                          //TODO: accept cancel
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                                CusRaisedButton(
                                                              title:
                                                                  'Chấp nhận',
                                                              backgroundColor:
                                                                  kColorBlack,
                                                              onPress:
                                                                  () async {
                                                                String
                                                                    adminName =
                                                                    await StorageUtil
                                                                        .geFullName();
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .doc(document[
                                                                        'sub_Id'])
                                                                    .update({
                                                                  'status':
                                                                      'Canceled',
                                                                  'description':
                                                                      (description ==
                                                                              null)
                                                                          ? '   '
                                                                          : description,
                                                                  'admin':
                                                                      'None'
                                                                });
                                                                //TODO: increase quantity
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .doc(document[
                                                                        'sub_Id'])
                                                                    .collection(
                                                                        document[
                                                                            'id'])
                                                                    .get()
                                                                    .then(
                                                                        (document) {
                                                                  List<QuantityOrder>
                                                                      quantityOrderList =
                                                                      [];
                                                                  for (var document
                                                                      in document
                                                                          .docs) {
                                                                    QuantityOrder
                                                                        quantityOrder =
                                                                        new QuantityOrder(
                                                                            productId:
                                                                                document['id'],
                                                                            quantity: int.parse(document['quantity']));
                                                                    quantityOrderList
                                                                        .add(
                                                                            quantityOrder);
                                                                  }
                                                                  for (var qtyOrder
                                                                      in quantityOrderList) {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Products')
                                                                        .doc(qtyOrder
                                                                            .productId)
                                                                        .get()
                                                                        .then(
                                                                            (document) {
                                                                      int quantity =
                                                                          int.parse(
                                                                              document.data()['quantity']);
                                                                      int result =
                                                                          quantity +
                                                                              qtyOrder.quantity;
                                                                      print(
                                                                          result);
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Products')
                                                                          .doc(qtyOrder
                                                                              .productId)
                                                                          .update({
                                                                        'quantity':
                                                                            result.toString(),
                                                                      });
                                                                    });
                                                                  }
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: ConstScreen
                                                                .setSizeWidth(
                                                                    20),
                                                          ),
                                                          //TODO: cancel
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                                CusRaisedButton(
                                                              title: 'Hủy',
                                                              backgroundColor:
                                                                  kColorWhite,
                                                              onPress: () {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );
                              })
                              .toList()
                              .reversed
                              .toList(),
                        );
                      } else
                        return Container();
                    });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          )),
    );
  }
}
