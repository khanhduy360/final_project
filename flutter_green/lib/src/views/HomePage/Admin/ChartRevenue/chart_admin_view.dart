import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_green/src/helpers/TextStyle.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';

import 'OrderChart.dart';
import 'priceVolatilityChart.dart';
import 'revenue_chart.dart';

class AdminChartView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdminChartView();
}

class _AdminChartView extends State with SingleTickerProviderStateMixin {
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
        centerTitle: true,
        title: Text(
          'Chart',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
        bottom: TabBar(
          unselectedLabelColor: Colors.black.withOpacity(0.5),
          labelColor: Colors.lightBlueAccent,
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.insert_chart,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Revenue',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.pie_chart,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Order & Bill',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.monetization_on,
                size: ConstScreen.setSizeHeight(30),
              ),
              child: Text(
                'Price Volatility',
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
              ),
            )
          ],
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          //TODO: Revenue
          RevenueChart(),
          //TODO: Order Analysis
          OrderChart(),
          //TODO: Price Volatility
          PriceVolatilityChart(),
        ],
        controller: _tabController,
      ),
    );
  }
}
