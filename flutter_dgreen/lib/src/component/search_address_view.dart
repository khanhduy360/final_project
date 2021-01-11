import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../env.dart' as env;

class SearchAddressView extends StatefulWidget {
  SearchAddressView({this.onClickResult, this.title = 'Điểm đi'});
  final Function onClickResult;
  final String title;
  static const styleDot =
      TextStyle(height: 0.3, fontSize: 22, color: kColorGrey);

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  TextEditingController cDestinationSearch = TextEditingController();
  List<SearchResult> listResult = [];

  getPositionByAddress(String address) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&region=vn&key=${env.googleKeyAPI}';
    final response = await http.get(baseUrl);

    if (response.statusCode == 200) {
      var dataResponse = jsonDecode(response.body);

      final results = dataResponse['results'];
      if (results.length > 0) {
        var location = results[0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    }
  }

  getLocationResult(String input) async {
    print('getLocationResult $input');
    List<SearchResult> newListResult = [];
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseUrl?input=$input&key=${env.googleKeyAPI}&language=vn&components=country:vn';
    final response = await http.get(request);
    print('getLocationResult: ${response.statusCode}');
    print('getLocationResult: ${jsonDecode(response.body)}');
    if (response.statusCode == 200) {
      var dataResponse = jsonDecode(response.body);
      final predictions = dataResponse['predictions'];
      for (var i = 0; i < predictions.length; i++) {
        String name = predictions[i]['structured_formatting']['main_text'];
        String address = predictions[i]['description'];
        String distance = predictions[i]['distance'];
        newListResult.add(
            SearchResult(name: name, address: address, distance: distance));
      }
      setState(() {
        listResult = newListResult;
      });
    } else {
      print('getLocationResult: $response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.arrow_back,
                size: 18,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: setHeightSize(size: 5)),
          Container(
            padding: EdgeInsets.all(setHeightSize(size: 15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: kColorGrey, blurRadius: 15, spreadRadius: 0.1),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontFamily: kFontMontserratBold, color: kColorBody),
                      ),
                      TextField(
                        onChanged: (value) {
                          getLocationResult(value);
                        },
                        controller: cDestinationSearch,
                        autofocus: true,
                        maxLines: null,
                        minLines: 2,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: kColorLightGrey, width: 1.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                cDestinationSearch.text = '';
                                getLocationResult('');
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: kColorGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: setHeightSize(size: 15)),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: kColorGrey, blurRadius: 15, spreadRadius: 0.1),
                ],
              ),
              child: listResult.length <= 0
                  ? Center(child: Text('Không có kết quả!'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            String shortAddress = listResult[index].name;
                            LatLng location = await getPositionByAddress(
                                listResult[index].address);
                            widget.onClickResult(listResult[index].address,
                                location, shortAddress);
                            Navigator.pop(context);
                          },
                          child: ResultItem(
                            name: listResult[index].name,
                            address: listResult[index].address,
                            distance: listResult[index].distance,
                          ),
                        );
                      },
                      itemCount: listResult.length,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResult {
  String name;
  String address;
  String distance;

  SearchResult({this.name, this.address, this.distance});
}

class ResultItem extends StatelessWidget {
  ResultItem({this.name, this.address, this.distance});

  final String name;
  final String address;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            name,
          ),
          subtitle: Text(
            '$address',
            style: TextStyle(fontSize: 12),
          ),
        ),
        SizedBox(
          height: 15,
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }
}
