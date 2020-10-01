import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/utils.dart';
import 'package:flutter_green/src/widgets/category_item.dart';

class PriceVolatilityChart extends StatefulWidget {
  @override
  _PriceVolatilityChartState createState() => _PriceVolatilityChartState();
}

class _PriceVolatilityChartState extends State<PriceVolatilityChart> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.documents.map((document) {
                return Card(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('PriceVolatility')
                          .orderBy('timeCreate')
                          .where('product_id', isEqualTo: document.documentID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<CategoryItem> listPriceVolatility = [];
                        if (snapshot.hasData) {
                          for (var docs in snapshot.data.documents) {
                            var widget = CategoryItem(
                              title: 'Price: ' +
                                  Util.intToMoneyType(
                                      int.parse(docs.data['price'])) +
                                  ' VND\nSale price: ' +
                                  Util.intToMoneyType(
                                      int.parse(docs.data['sale_price'])) +
                                  ' VND\nCreate at: ' +
                                  Util.convertDateToFullString(
                                      docs.data['create_at']),
                              height: 130,
                            );
                            listPriceVolatility.add(widget);
                          }
                        }
                        return ExpansionTile(
                          title: Text(
                              'ID: ${document.data['id']}\nProduct: ${document.data['name']}'),
                          children: listPriceVolatility.reversed.toList(),
                        );
                      }),
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        });
  }
}
