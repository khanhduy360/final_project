import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RatingComment extends StatelessWidget {
  RatingComment(
      {this.username = '',
      this.comment = '',
      this.ratingPoint = 0,
      this.createAt = '',
      this.isAdmin,
      this.isCanDelete,
      this.onDelete});
  final String comment;
  final String username;
  final double ratingPoint;
  final String createAt;
  final bool isAdmin;
  final bool isCanDelete;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: isCanDelete
            ? <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    onDelete();
                  },
                ),
              ]
            : null,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: kColorBlack.withOpacity(0.2), width: 1),
            bottom: BorderSide(color: kColorBlack.withOpacity(0.2), width: 1),
          )),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: ConstScreen.setSizeWidth(5),
                horizontal: ConstScreen.setSizeWidth(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //TODO: Username + RatingBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AutoSizeText(
                          username,
                          style: TextStyle(
                              fontSize: FontSize.s25,
                              fontWeight: FontWeight.bold,
                              color: isAdmin ? kColorRed : kColorBlack),
                          maxLines: 1,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          width: ConstScreen.setSizeWidth(20),
                        ),
                        (!isAdmin)
                            ? RatingBar(
                                allowHalfRating: true,
                                initialRating: ratingPoint,
                                itemCount: 5,
                                minRating: 0,
                                itemSize: ConstScreen.setSizeHeight(35),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: AutoSizeText(
                        createAt,
                        style: TextStyle(
                            fontSize: FontSize.s25,
                            fontWeight: FontWeight.w400),
                        maxLines: 1,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                // Comment
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: ConstScreen.setSizeHeight(5),
                      horizontal: ConstScreen.setSizeWidth(8)),
                  child: AutoSizeText(
                    comment,
                    minFontSize: 14,
                    style: TextStyle(fontSize: FontSize.s23),
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis,
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
