import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/model/product.dart';

class DetailOfProductPage extends StatefulWidget {
  DetailOfProductPage({this.product, Key key}) : super(key: key);
  final Product product;
  @override
  _DetailOfProductPageState createState() => _DetailOfProductPageState();
}

class _DetailOfProductPageState extends State<DetailOfProductPage>
    with AutomaticKeepAliveClientMixin {
  String description = '';
  String brand = '';
  String madeIn = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    description = widget.product.description;
    brand = widget.product.brand;
    madeIn = widget.product.madeIn;
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: IconButton(
            color: kColorBlack,
            iconSize: ConstScreen.setSizeWidth(55),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: ConstScreen.setSizeWidth(40),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0, horizontal: ConstScreen.setSizeWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Mô tả:',
                style: TextStyle(
                    fontSize: FontSize.setTextSize(40),
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: ConstScreen.setSizeWidth(15),
                      top: ConstScreen.setSizeHeight(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Description
                      AutoSizeText(
                        description,
                        style: TextStyle(fontSize: 18),
                        minFontSize: 14,
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Made in
                      SizedBox(
                        height: ConstScreen.setSizeHeight(10),
                      ),
                      AutoSizeText(
                        'Thương hiệu: $brand.\nXuất xứ: $madeIn.',
                        style: TextStyle(fontSize: 18),
                        minFontSize: 14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
