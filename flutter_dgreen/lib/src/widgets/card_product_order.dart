import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/textline_between.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/widget_title.dart';

class ProductOrderDetail extends StatelessWidget {
  ProductOrderDetail(
      {this.name = '',
      this.price = '',
      this.quantity = '',
      this.color = kColorWhite});

  final String name;
  final String price;
  final String quantity;

  final Color color;
  @override
  Widget build(BuildContext context) {
    int subTotal = int.parse(quantity) * int.parse(price);
    String subPriceMoneyType = Util.intToMoneyType(subTotal);
    String priceMoneyType = Util.intToMoneyType(int.parse(price));

    ConstScreen.setScreen(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kColorBlack.withOpacity(0.2),
            width: ConstScreen.setSizeWidth(4),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            bottom: ConstScreen.setSizeHeight(15),
            left: ConstScreen.setSizeHeight(27)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: ConstScreen.setSizeWidth(20),
            ),
            // TODO: Product name
            TextLineBetween(
                label: 'Tên sản phẩm ',
                content: name,
                contentStyle: TextStyle(
                    color: kColorGreen,
                    fontFamily: kFontMontserratBold,
                    fontSize: 16)),

            //TODO: Color
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: AutoSizeText(
                    'Màu:',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.s30, color: kColorGreen),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: ConstScreen.setSizeHeight(30),
                    width: ConstScreen.setSizeHeight(30),
                    decoration: BoxDecoration(
                        color: color, border: Border.all(color: kColorBlack)),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstScreen.setSizeWidth(20),
            ),
            //TODO: Price
            TextLineBetween(
                label: 'Giá sản phẩm ',
                content: '$priceMoneyType VND',
                contentStyle: TextStyle(
                    color: kColorGreen,
                    fontFamily: kFontMontserratBold,
                    fontSize: 16)),
            //TODO: Quantity
            TextLineBetween(
                label: 'Số lượng: ',
                content: quantity,
                contentStyle: TextStyle(
                    color: kColorGreen,
                    fontFamily: kFontMontserratBold,
                    fontSize: 16)),
            //TODO: SubTotal
            TextLineBetween(
                label: 'Tổng ',
                content: '$subPriceMoneyType VND',
                contentStyle: TextStyle(
                    color: kColorGreen,
                    fontFamily: kFontMontserratBold,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
