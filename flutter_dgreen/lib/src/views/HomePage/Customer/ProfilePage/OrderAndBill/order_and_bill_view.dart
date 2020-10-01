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
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/card_order.dart';

import 'order_info_view.dart';

class OrderAndBillView extends StatefulWidget {
  OrderAndBillView({this.status, this.isAdmin = false});
  final String status;
  final bool isAdmin;
  @override
  _OrderAndBillViewState createState() => _OrderAndBillViewState();
}

class _OrderAndBillViewState extends State<OrderAndBillView> {
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
                    stream: widget.isAdmin
                        ? Firestore.instance
                            .collection('Orders')
                            .where('status', isEqualTo: widget.status)
                            .orderBy('create_at')
                            .snapshots()
                        : Firestore.instance
                            .collection('Orders')
                            .where('id', isEqualTo: uid)
                            .where('status', isEqualTo: widget.status)
                            .orderBy('create_at')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (mainSnapshot.hasData && snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.documents
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
                                                          'Cancel Order',
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
                                                              hintStyle:
                                                                  kBoldTextStyle
                                                                      .copyWith(
                                                                          fontSize: FontSize
                                                                              .s25),
                                                              hintText:
                                                                  'Description',
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
                                                              title: 'ACCEPT',
                                                              backgroundColor:
                                                                  kColorBlack,
                                                              onPress:
                                                                  () async {
                                                                String
                                                                    adminName =
                                                                    await StorageUtil
                                                                        .geFullName();
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .document(
                                                                        document[
                                                                            'sub_Id'])
                                                                    .updateData({
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
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'Orders')
                                                                    .document(
                                                                        document[
                                                                            'sub_Id'])
                                                                    .collection(
                                                                        document[
                                                                            'id'])
                                                                    .getDocuments()
                                                                    .then(
                                                                        (document) {
                                                                  List<QuantityOrder>
                                                                      quantityOrderList =
                                                                      [];
                                                                  for (var document
                                                                      in document
                                                                          .documents) {
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
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            'Products')
                                                                        .document(qtyOrder
                                                                            .productId)
                                                                        .get()
                                                                        .then(
                                                                            (document) {
                                                                      int quantity =
                                                                          int.parse(
                                                                              document.data['quantity']);
                                                                      int result =
                                                                          quantity +
                                                                              qtyOrder.quantity;
                                                                      print(
                                                                          result);
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              'Products')
                                                                          .document(
                                                                              qtyOrder.productId)
                                                                          .updateData({
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
                                                              title: 'CANCEL',
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
