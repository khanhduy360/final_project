import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/views/HomePage/Admin/Bill/bill_detail.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_and_bill_view.dart';

class AdminBillView extends StatefulWidget {
  AdminBillView({this.isAdmin = false});
  final bool isAdmin;
  @override
  _AdminBillViewState createState() => _AdminBillViewState();
}

class _AdminBillViewState extends State<AdminBillView>
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
        iconTheme: IconThemeData(color: kColorGreen),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Hóa đơn',
          style: TextStyle(
              color: kColorGreen,
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
                Icons.check_circle,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Hoàn thành',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.cancel,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Đã hủy',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        children: [
          //TODO: Bill
          BillDetail(
            status: 'Completed',
            isAdmin: true,
          ),
          BillDetail(
            status: 'Canceled',
            isAdmin: true,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}
