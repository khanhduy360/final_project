import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'box_info.dart';
import 'widget_title.dart';

class AdminProductCard extends StatelessWidget {
  AdminProductCard(
      {this.productName = '',
      this.productSizeList,
      this.productColorList,
      this.productPrice = 0,
      this.productImage = '',
      this.productSalePrice = 0,
      this.category = '',
      this.createAt = '',
      this.quantity = '1',
      this.brand = '',
      this.madeIn = '',
      this.onClose,
      this.onEdit,
      this.onComment});
  final String productName;
  final List productColorList;
  final List productSizeList;
  final int productPrice;
  final int productSalePrice;
  final String productImage;
  final String quantity;
  final String brand;
  final String madeIn;
  final String category;
  final String createAt;
  final Function onClose;
  final Function onEdit;
  final Function onComment;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Card(
          child: Container(
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
                      child: CachedNetworkImage(
                        imageUrl: productImage,
                        fit: BoxFit.fill,
                        height: ConstScreen.setSizeHeight(400),
                        width: ConstScreen.setSizeWidth(280),
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  //TODO: Detail product
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TitleWidget(
                          title: 'Name: ',
                          content: productName,
                        ),
                        TitleWidget(
                          title: 'Quantity: ',
                          content: quantity,
                        ),
                        TitleWidget(
                          title: 'Price: ',
                          content: '${Util.intToMoneyType(productPrice)} VND',
                        ),
                        TitleWidget(
                          title: 'SalePrice: ',
                          content:
                              '${Util.intToMoneyType(productSalePrice)} VND',
                        ),
                        TitleWidget(
                          title: 'Brand: ',
                          content: brand,
                        ),
                        TitleWidget(
                          title: 'Categogy: ',
                          content: category,
                        ),
                        TitleWidget(
                          title: 'Made in: ',
                          content: madeIn,
                        ),
                        TitleWidget(
                          title: 'Create at: ',
                          content: createAt,
                        ),
                        TitleWidget(
                          title: 'Size: ',
                          content: (productSizeList != null)
                              ? '$productSizeList'
                              : 'None',
                        ),
                        Row(
                          children: <Widget>[
                            AutoSizeText(
                              '   Color: ',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              style: kBoldTextStyle.copyWith(
                                  fontSize: FontSize.s30,
                                  color: kColorBlack.withOpacity(0.5)),
                            ),
                            (productColorList != null)
                                ? Row(
                                    children: productColorList.map((color) {
                                      return BoxInfo(
                                        color: Color(color),
                                        size: 25,
                                      );
                                    }).toList(),
                                  )
                                : AutoSizeText(
                                    '       None',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    style: kBoldTextStyle.copyWith(
                                        fontSize: FontSize.s30,
                                        color: kColorBlack),
                                  ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Comment',
            color: Colors.blueAccent,
            icon: Icons.insert_comment,
            onTap: () {
              onComment();
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.black45,
            icon: Icons.edit,
            onTap: () {
              onEdit();
            },
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              onClose();
            },
          ),
        ]);
  }
}
// TODO: Quantity
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          // TODO: Quantity Down Button
//                          Container(
//                            height: ConstScreen.setSizeHeight(60),
//                            width: ConstScreen.setSizeHeight(80),
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                  color: kColorBlack.withOpacity(0.6)),
//                              borderRadius: BorderRadius.horizontal(
//                                left: Radius.circular(20),
//                              ),
//                            ),
//                            //TODO: DOWN
//                            child: Center(
//                              child: IconButton(
//                                icon: Icon(
//                                  Icons.arrow_back_ios,
//                                ),
//                                iconSize: ConstScreen.setSizeWidth(25),
//                                onPressed: () => onDismissed(counter),
//                              ),
//                            ),
//                          ),
//                          //TODO: Quantity value
//                          Container(
//                            height: ConstScreen.setSizeHeight(60),
//                            width: ConstScreen.setSizeHeight(200),
//                            decoration: BoxDecoration(
//                                border: Border(
//                              top: BorderSide(
//                                  color: kColorBlack.withOpacity(0.6)),
//                              bottom: BorderSide(
//                                  color: kColorBlack.withOpacity(0.6)),
//                            )),
//                            child: Center(
//                              child: Text(
//                                '0',
//                                style: TextStyle(fontSize: FontSize.s28),
//                              ),
//                            ),
//                          ),
//                          // TODO: Quantity Up Button
//                          Container(
//                            height: ConstScreen.setSizeHeight(60),
//                            width: ConstScreen.setSizeHeight(80),
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                color: kColorBlack.withOpacity(0.6),
//                              ),
//                              borderRadius: BorderRadius.horizontal(
//                                right: Radius.circular(20),
//                              ),
//                            ),
//                            //TODO: UP
//                            child: Center(
//                              child: IconButton(
//                                icon: Icon(
//                                  Icons.arrow_forward_ios,
//                                ),
//                                iconSize: ConstScreen.setSizeWidth(25),
//                                onPressed: () => onDecrement(counter),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
