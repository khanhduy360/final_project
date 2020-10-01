import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class ItemOrder extends StatelessWidget {
  const ItemOrder(
      {Key key,
      this.productName = '',
      this.quantity = '',
      this.price = '',
      this.size = '',
      this.color = kColorWhite})
      : super(key: key);
  final String productName;
  final String quantity;
  final String price;
  final String size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    int subTotal = int.parse(quantity) * int.parse(price);
    String subPriceMoneyType = Util.intToMoneyType(subTotal);
    String priceMoneyType = Util.intToMoneyType(int.parse(price));
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kColorBlack.withOpacity(0.15),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ConstScreen.setSizeHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // TODO: product name
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    productName,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    minFontSize: 15,
                    style: TextStyle(
                        fontSize: FontSize.setTextSize(28),
                        color: kColorBlack,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                //TODO: Price
                Expanded(
                  flex: 3,
                  child: AutoSizeText(
                    'Subtotal: $subPriceMoneyType VND',
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    minFontSize: 15,
                    style: TextStyle(
                        fontSize: FontSize.setTextSize(28),
                        color: kColorBlack,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //TODO: Color
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        'Color ',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 15,
                        style: TextStyle(
                            fontSize: FontSize.setTextSize(28),
                            color: kColorBlack,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: ConstScreen.setSizeWidth(15),
                      ),
                      Container(
                        height: ConstScreen.setSizeHeight(30),
                        width: ConstScreen.setSizeHeight(30),
                        decoration: BoxDecoration(
                            color: color,
                            border: Border.all(color: kColorBlack)),
                      ),
                    ],
                  ),
                ),
                //TODO: Size
                Expanded(
                  flex: 1,
                  child: AutoSizeText(
                    'Size $size',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 15,
                    style: TextStyle(
                        fontSize: FontSize.setTextSize(28),
                        color: kColorBlack,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                //TODO: SubTotal:
                Expanded(
                  flex: 1,
                  child: AutoSizeText(
                    'Qty $quantity',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 15,
                    style: TextStyle(
                        fontSize: FontSize.setTextSize(28),
                        color: kColorBlack,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
