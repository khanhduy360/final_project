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
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ConstScreen.setSizeWidth(20),
                          vertical: ConstScreen.setSizeHeight(40)),
                      child: CachedNetworkImage(
                        imageUrl: productImage,
                        fit: BoxFit.fill,
                        height: ConstScreen.setSizeHeight(280),
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
                          title: 'Tên sản phẩm: ',
                          content: productName,
                        ),
                        TitleWidget(
                          title: 'Số lượng: ',
                          content: quantity,
                        ),
                        TitleWidget(
                          title: 'Giá: ',
                          content: '${Util.intToMoneyType(productPrice)} VND',
                        ),
                        TitleWidget(
                          isSpaceBetween: true,
                          title: 'Giá khuyến mãi: ',
                          content:
                              '${Util.intToMoneyType(productSalePrice)} VND',
                        ),
                        TitleWidget(
                          title: 'Thương hiệu: ',
                          content: brand,
                        ),
                        TitleWidget(
                          title: 'Loại: ',
                          content: category,
                        ),
                        TitleWidget(
                          title: 'Xuất xứ: ',
                          content: madeIn,
                        ),
                        TitleWidget(
                          isSpaceBetween: true,
                          title: 'Ngày thêm: ',
                          content: createAt,
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
            caption: 'Bình luận',
            color: Colors.blueAccent,
            icon: Icons.insert_comment,
            onTap: () {
              onComment();
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Chỉnh sửa',
            color: Colors.black45,
            icon: Icons.edit,
            onTap: () {
              onEdit();
            },
          ),
          IconSlideAction(
            caption: 'Xóa',
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
