import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/box_dashboard.dart';
import 'package:flutter_dgreen/src/widgets/card_dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ChartRevenue/chart_admin_view.dart';
import 'OrderAndSold/sold_and_order_view.dart';

class AdminHomeView extends StatefulWidget {
  @override
  _AdminHomeViewState createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  String _userCount = '0';
  String _productCount = '0';
  String _orderCount = '0';
  String _soldCount = '0';
  String total = '0';
  String privateCouponCount = '0';
  String globalCouponCount = '0';
  loadNumberDashboard() {
    //TODO: User
    FirebaseFirestore.instance.collection('Users').get().then((onValue) {
      setState(() {
        _userCount = onValue.docs.length.toString();
      });
    });
    //TODO:Order
    FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Pending')
        .get()
        .then((onValue) {
      setState(() {
        _orderCount = onValue.docs.length.toString();
      });
    });
    //TODO: Product
    FirebaseFirestore.instance.collection('Products').get().then((onValue) {
      setState(() {
        _productCount = onValue.docs.length.toString();
      });
    });
    //TODO:Sold
    FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isLessThan: 'Pending')
        .get()
        .then((onValue) {
      setState(() {
        _soldCount = onValue.docs.length.toString();
      });
    });
    //TODO: Revenue
    FirebaseFirestore.instance
        .collection('Orders')
        .where('status', isEqualTo: 'Completed')
        .get()
        .then((document) {
      int revenue = 0;
      for (var order in document.docs) {
        int value = int.parse(order.data()['total']);
        revenue += value;
      }
      setState(() {
        total = Util.intToMoneyType(revenue);
      });
    });
    //TODO: Coupon
    FirebaseFirestore.instance
        .collection('Coupon')
        .where('uid', isLessThan: 'global')
        .get()
        .then((value) {
      privateCouponCount = value.docs.length.toString();
    });
    FirebaseFirestore.instance
        .collection('Coupon')
        .where('uid', isEqualTo: 'global')
        .get()
        .then((value) {
      globalCouponCount = value.docs.length.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    loadNumberDashboard();
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: kBoldTextStyle.copyWith(
              fontSize: FontSize.setTextSize(50), fontWeight: FontWeight.w900),
        ),
        centerTitle: false,
        backgroundColor: kColorWhite,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ConstScreen.setSizeWidth(30)),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: GestureDetector(
                  onTap: () {
                    StorageUtil.clear();
                    Navigator.pushNamedAndRemoveUntil(context, 'welcome_screen',
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    'Sign out',
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.s30, color: kColorBlue),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.blueAccent.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: DashboardCard(
                title: 'Revenue',
                color: Colors.orange.shade500,
                icon: FontAwesomeIcons.dollarSign,
                value: '$total VND',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminChartView()));
                },
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(10),
            ),
            //TODO: Users and Order
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardBox(
                      title: 'Users',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.users,
                      value: _userCount,
                      onPress: () {
                        Navigator.pushNamed(context, 'admin_user_manager');
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardBox(
                      title: 'Orders',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.shoppingCart,
                      value: _orderCount,
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SoldAndOrderView(
                                      title: 'Order List',
                                    )));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
            //TODO: Product and Sold
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DashboardBox(
                      title: 'Product',
                      color: kColorBlue,
                      icon: FontAwesomeIcons.productHunt,
                      value: _productCount,
                      onPress: () {
                        Navigator.pushNamed(context, 'admin_home_product');
                      },
                    ),
                  ),
                  Expanded(
                    child: DashboardBox(
                      title: 'Bill',
                      color: kColorBlue,
                      icon: Icons.done_outline,
                      value: _soldCount,
                      onPress: () {
                        Navigator.pushNamed(
                            context, 'admin_bill_history_screen');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
            //TODO: Edit Page
            Expanded(
              flex: 2,
              child: DashboardBox(
                title: 'Coupon',
                color: kColorBlue,
                icon: FontAwesomeIcons.ticketAlt,
                value:
                    'Private: $privateCouponCount  Global: $globalCouponCount',
                onPress: () {
                  Navigator.pushNamed(context, 'admin_coupon_manager');
                },
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(50),
            )
          ],
        ),
      ),
    );
  }
}
