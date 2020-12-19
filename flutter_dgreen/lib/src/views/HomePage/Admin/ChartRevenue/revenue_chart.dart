import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:validators/sanitizers.dart';

class RevenueChart extends StatefulWidget {
  @override
  _RevenueChartState createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  int totalSale = 0;

  DateTime yearPick;
  TextEditingController yController = TextEditingController();

  List<OrdinalSales> chartData = [
    new OrdinalSales('1', 0),
    new OrdinalSales('2', 0),
    new OrdinalSales('3', 0),
    new OrdinalSales('4', 0),
    new OrdinalSales('5', 0),
    new OrdinalSales('6', 0),
    new OrdinalSales('7', 0),
    new OrdinalSales('8', 0),
    new OrdinalSales('9', 0),
    new OrdinalSales('10', 0),
    new OrdinalSales('11', 0),
    new OrdinalSales('12', 0),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    yearPick = DateTime.now();
    getDataForChart(yearPick.year);
  }

  //TODO: Chart Data
  List<charts.Series<OrdinalSales, String>> _chartData() {
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        labelAccessorFn: (OrdinalSales sales, _) => '${sales.sales}',
        data: chartData,
      )
    ];
  }

  //TODO: Get total sale per month
  Future<int> getTotalPerMonth(int month, int year) async {
    int total = 0;
    var snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .where('status', isEqualTo: 'Completed')
        .get();
    if (snapshot.docs.length != 0) {
      for (var document in snapshot.docs) {
        total += int.parse(document.data()['total']);
      }
      return total;
    } else {
      return 0;
    }
  }

  //TODO: get all Data
  getDataForChart(int year) {
    totalSale = 0;
    for (int index = 0; index < 12; index++) {
      getTotalPerMonth(index + 1, year.toInt()).then((total) {
        setState(() {
          totalSale += total;
          chartData.elementAt(index).sales = total;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ConstScreen.setSizeWidth(15),
          vertical: ConstScreen.setSizeHeight(15)),
      child: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ConstScreen.setSizeHeight(10),
                  horizontal: ConstScreen.setSizeWidth(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Tổng thu: ',
                    style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${Util.intToMoneyType(totalSale)} VND',
                    style: kBoldTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: FontSize.s36,
                        color: kColorOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          //TODO: Chart
          Expanded(
            flex: 3,
            child: Card(
              child: charts.BarChart(
                _chartData(),
                animate: true,
                vertical: false,
                behaviors: [
                  new charts.SlidingViewport(),
                  new charts.PanAndZoomBehavior(),
                ],
                barRendererDecorator: new charts.BarLabelDecorator(
                  insideLabelStyleSpec: charts.TextStyleSpec(
                      fontSize: FontSize.s28.floor(),
                      color: charts.MaterialPalette.white),
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                      fontSize: FontSize.s28.floor(),
                      color: charts.MaterialPalette.black),
                ),
                // Hide domain axis.
              ),
            ),
          ),
          //TODO: year picker
          Expanded(
            flex: 1,
            child: Card(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: ConstScreen.setSizeWidth(10),
                  ),
                  Text(
                    'Chọn năm:',
                    style: kBoldTextStyle.copyWith(fontSize: FontSize.s36),
                    textAlign: TextAlign.start,
                  ),
                  //TODO: Year picker
                  Container(
                    height: ConstScreen.setSizeHeight(300),
                    width: ConstScreen.setSizeWidth(300),
                    child: YearPicker(
                      dragStartBehavior: DragStartBehavior.start,
                      firstDate: DateTime.utc(2010),
                      lastDate: DateTime.now(),
                      selectedDate: yearPick,
                      onChanged: (date) {
                        setState(() {
                          yearPick = date;
                          getDataForChart(yearPick.year);
                        });
                      },
                    ),
                  ),
                  Text(
                    'Hiện là \n ${yearPick.year}',
                    style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  yearPicker() {
    final year = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Chọn năm',
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 4.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200],
            child: CalendarDatePicker(
              initialDate: DateTime(year - 10),
              firstDate: DateTime(year - 10),
              lastDate: DateTime(year + 10),
              initialCalendarMode: DatePickerMode.year,
              onDateChanged: (value) {
                yController.text = value.toString().substring(0, 4);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

class OrdinalSales {
  String month;
  int sales;

  OrdinalSales(this.month, this.sales);
}
