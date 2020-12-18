import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/box_card.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class OfferList extends StatelessWidget {
  final List offer;

  const OfferList({Key key, this.offer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _widthScreen = MediaQuery.of(context).size.width;
    double _widthContentOdd = (_widthScreen - 15) * 1 / 2;
    double _widthContentEven = (_widthScreen - 15) * 2 / 3;
    return Column(
      children: List.generate(offer.length, (index) {
        var _item = offer[index];
        return BoxCard(
          marginVertical: 10,
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                  child: Positioned(
                    width: _widthScreen - 30,
                    bottom: 0,
                    child: Align(
                      alignment: (index / 2) == 0
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight,
                      child: Container(
                        width: (_widthScreen - 15) * 2 / 3,
                        child: Image.asset(
                            'lib/src/assets/images/${_item["img"]}'),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment:
                      (index / 2) == 0 ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    width:
                        (index / 2) == 0 ? _widthContentOdd : _widthContentEven,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 31,
                    ),
                    child: OfferInfo(item: _item),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class OfferInfo extends StatelessWidget {
  final dynamic item;

  const OfferInfo({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(7.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0xFF00BCD4),
          ),
          child: Text(
            'Giảm giá ${item["offer"]}%',
            style: TextStyle(
              color: Colors.white,
              fontFamily: kFontMontserrat,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: 7.46,
        ),
        Text(
          '${item['description']}',
          style: TextStyle(
            color: kColorOrange,
            fontSize: 10,
            fontFamily: kFontMontserrat,
          ),
        ),
        SizedBox(
          height: 7.46,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item["textBtn"],
              style: TextStyle(height: 1, fontFamily: kFontMontserratBold),
            ),
            SizedBox(
              width: 8,
            ),
            Icon(
              Icons.arrow_right,
              size: setFontSize(size: 14),
            ),
          ],
        ),
      ],
    );
  }
}
