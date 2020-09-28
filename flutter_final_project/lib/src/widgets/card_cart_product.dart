import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';
import 'package:flutter_final_project/src/helpers/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'box_info.dart';

class CartProductCard extends StatelessWidget {
  CartProductCard({
    this.id,
    this.productName = '',
    this.productSize = '',
    this.productColor = kColorWhite,
    this.productPrice = 0,
    this.productImage = '',
    this.productSalePrice = 0,
    this.quantity = '1',
    this.brand,
    this.madeIn,
    this.onQtyChange,
    this.onClose,
  });
  final String productName;
  final Color productColor;
  final String productSize;
  final int productPrice;
  final int productSalePrice;
  final String productImage;
  final String quantity;
  final String brand;
  final String madeIn;
  final Function onClose;
  final Function onQtyChange;
  final String id;

  @override
  Widget build(BuildContext context) {
    double discount = 100 - ((productSalePrice / productPrice) * 100);
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onClose();
            },
          ),
        ],
        child: Container(
          height: ConstScreen.setSizeHeight(420),
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: ConstScreen.setSizeHeight(15)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO: Image Product
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ConstScreen.setSizeWidth(20)),
                    child: Stack(
                      children: <Widget>[
                        //TODO: image
                        CachedNetworkImage(
                          imageUrl: productImage,
                          fit: BoxFit.fill,
                          height: ConstScreen.setSizeHeight(400),
                          width: ConstScreen.setSizeWidth(280),
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    ),
                  ),
                ),
                //TODO: Detail product
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //// TODO: Name Product
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                productName,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: FontSize.setTextSize(36),
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            //TODO: Brand
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                'Brand: $brand',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: FontSize.setTextSize(34),
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            //TODO: Made In
                            Align(
                              alignment: Alignment.topLeft,
                              child: AutoSizeText(
                                'Made in: $madeIn',
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                minFontSize: 15,
                                style: TextStyle(
                                    fontSize: FontSize.setTextSize(34),
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            // TODO: Size, color Product and Quantity
                            Row(
                              children: <Widget>[
                                // TODO: Product Color
                                Expanded(
                                  flex: 1,
                                  child: BoxInfo(
                                    color: productColor,
                                  ),
                                ),
                                SizedBox(
                                  width: ConstScreen.setSizeWidth(5),
                                ),
                                // TODO: Product Size
                                Expanded(
                                  flex: 1,
                                  child: BoxInfo(
                                    sizeProduct: productSize,
                                  ),
                                ),
                                SizedBox(
                                  width: ConstScreen.setSizeWidth(180),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: //TODO: quantity
                                      Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: ConstScreen.setSizeWidth(20)),
                                    child: TextFormField(
                                      initialValue: quantity,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        hintStyle: kBoldTextStyle.copyWith(
                                            fontSize: FontSize.s28,
                                            fontWeight: FontWeight.w200),
                                        focusColor: Colors.black,
                                      ),
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      onChanged: (qty) {
                                        onQtyChange(qty);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ConstScreen.setSizeWidth(5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: (productSalePrice == 0)
                              ? AutoSizeText(
                                  '${Util.intToMoneyType(productPrice)} VND',
                                  maxLines: 1,
                                  minFontSize: 10,
                                  style: TextStyle(
                                      fontSize: FontSize.setTextSize(42),
                                      color: kColorBlack,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.end,
                                )
                              : Column(
                                  children: <Widget>[
                                    //TODO: discount
                                    AutoSizeText(
                                      '${discount.toInt()}% OFF',
                                      maxLines: 1,
                                      minFontSize: 5,
                                      style: TextStyle(
                                          fontSize: FontSize.setTextSize(32),
                                          color: kColorRed,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.end,
                                    ),
                                    //TODO: price sale
                                    AutoSizeText(
                                      '${Util.intToMoneyType(productSalePrice)} VND',
                                      maxLines: 1,
                                      minFontSize: 5,
                                      style: TextStyle(
                                          fontSize: FontSize.setTextSize(42),
                                          color: kColorRed,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
