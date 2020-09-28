import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'global_coupon_view.dart';
import 'private_coupon_view.dart';

class CouponAdminView extends StatefulWidget {
  @override
  _CouponAdminViewState createState() => _CouponAdminViewState();
}

class _CouponAdminViewState extends State<CouponAdminView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Coupon List',
          style: TextStyle(
              color: kColorBlack,
              fontSize: FontSize.setTextSize(32),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.lightBlueAccent,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                FontAwesomeIcons.ticketAlt,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Private',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.ticketAlt,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Global',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          //TODO: private coupon
          PrivateCouponView(),
          //TODO: global coupon
          GlobalCouponView()
        ],
        controller: _tabController,
      ),
    );
  }
}
