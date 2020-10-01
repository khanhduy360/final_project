import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/widget_title.dart';

class ProductOrderDetail extends StatelessWidget {
  ProductOrderDetail(
      {this.name = '',
      this.price = '',
      this.quantity = '',
      this.size = '',
      this.color = kColorWhite});

  final String name;
  final String price;
  final String quantity;
  final String size;
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
            // TODO: Product name
            TitleWidget(
              title: 'Product Name: ',
              content: name,
              isSpaceBetween: false,
            ),
            //TODO: Size
            TitleWidget(
              title: 'Size: ',
              content: size,
              isSpaceBetween: false,
            ),
            //TODO: Color
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ConstScreen.setSizeHeight(10),
                  horizontal: ConstScreen.setSizeWidth(25)),
              child: Row(
                mainAxisAlignment: false
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: AutoSizeText(
                      'Color:',
                      maxLines: 1,
                      minFontSize: 10,
                      style: kBoldTextStyle.copyWith(
                          fontSize: FontSize.s30,
                          color: kColorBlack.withOpacity(0.5)),
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
                  Expanded(
                    flex: 7,
                    child: Container(),
                  ),
                ],
              ),
            ),
            //TODO: Price
            TitleWidget(
              title: 'Price: ',
              content: '$priceMoneyType VND',
              isSpaceBetween: false,
            ),
            //TODO: Quantity
            TitleWidget(
              title: 'Quantity: ',
              content: quantity,
              isSpaceBetween: false,
            ),
            //TODO: SubTotal
            TitleWidget(
              title: 'SubTotal: ',
              content: '$subPriceMoneyType VND',
              isSpaceBetween: false,
            ),
          ],
        ),
      ),
    );
  }
}
