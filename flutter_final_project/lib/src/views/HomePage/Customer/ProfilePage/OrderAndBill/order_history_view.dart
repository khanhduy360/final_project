import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

import 'order_and_bill_view.dart';

class OrderHistoryView extends StatefulWidget {
  OrderHistoryView({this.isAdmin = false});
  final bool isAdmin;
  @override
  _OrderHistoryViewState createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
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
          'Order And Bill',
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
                Icons.cached,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Pending',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.check_circle,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Completed',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.cancel,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Canceled',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          //TODO: Order
          OrderAndBillView(
            status: 'Pending',
            isAdmin: false,
          ),
          //TODO: Bill
          OrderAndBillView(
            status: 'Completed',
            isAdmin: false,
          ),
          OrderAndBillView(
            status: 'Canceled',
            isAdmin: false,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
