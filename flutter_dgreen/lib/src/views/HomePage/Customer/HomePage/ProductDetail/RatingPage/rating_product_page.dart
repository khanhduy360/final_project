import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/rating_comment_card.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'rating_controller.dart';

class RatingProductPage extends StatefulWidget {
  RatingProductPage({this.productId, this.isAdmin = false, Key key})
      : super(key: key);
  final String productId;
  final bool isAdmin;
  @override
  _RatingProductPageState createState() => _RatingProductPageState();
}

class _RatingProductPageState extends State<RatingProductPage>
    with AutomaticKeepAliveClientMixin {
  RatingController _controller = new RatingController();
  List commentList = [];
  bool _isLogging = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TOP
          Expanded(
            flex: 1,
            child: Container(
              color: kColorLightGrey.withOpacity(0.4),
              child: Stack(
                children: <Widget>[
                  //
                  Positioned(
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
                  Center(
                    child: Column(
                      children: <Widget>[
                        // Rating Bar
                        StreamBuilder(
                            stream: _controller.averageStream,
                            builder: (context, snapshot) {
                              return RatingBar.builder(
                                allowHalfRating: true,
                                initialRating:
                                    snapshot.hasData ? snapshot.data : 0,
                                itemCount: 5,
                                minRating: 0,
                                itemSize: ConstScreen.setSizeHeight(55),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                ),
                              );
                            }),
                        SizedBox(
                          height: ConstScreen.setSizeHeight(5),
                        ),
                        StreamBuilder(
                            stream: _controller.totalReviewStream,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData
                                    ? '${snapshot.data} Đánh giá'
                                    : '0 Đánh giá',
                                style: TextStyle(
                                    fontSize: FontSize.s30,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                      ],
                    ),
                  ),
                  //TODO: Add Comment
                  Positioned(
                    top: 0,
                    right: ConstScreen.setSizeWidth(20),
                    child: IconButton(
                        icon: Icon(
                          Icons.add_comment,
                          size: ConstScreen.setSizeWidth(45),
                        ),
                        onPressed: () {
                          //TODO: Add comment
                          if (_isLogging) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  double _ratingPoint = 0;
                                  String _comment = '';
                                  return Dialog(
                                    elevation: 0.0,
                                    backgroundColor: kColorWhite,
                                    child: Container(
                                      height: ConstScreen.setSizeHeight(600),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                ConstScreen.setSizeHeight(15),
                                            horizontal:
                                                ConstScreen.setSizeWidth(30)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            //Rating
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Điểm:',
                                                      style: TextStyle(
                                                          fontSize:
                                                              FontSize.s36,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Center(
                                                      child: RatingBar.builder(
                                                        itemCount: 5,
                                                        onRatingUpdate:
                                                            (value) {
                                                          _ratingPoint = value;
                                                        },
                                                        minRating: 0,
                                                        maxRating: 5,
                                                        allowHalfRating: true,
                                                        itemSize: ConstScreen
                                                            .setSizeWidth(70),
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .amberAccent,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  ConstScreen.setSizeHeight(20),
                                            ),
                                            // Comment
                                            Text(
                                              'Bình luận:',
                                              style: TextStyle(
                                                  fontSize: FontSize.s36,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Expanded(
                                                flex: 10,
                                                child: StreamBuilder(
                                                  stream:
                                                      _controller.commentStream,
                                                  builder:
                                                      (context, snapshot) =>
                                                          TextField(
                                                    decoration: InputDecoration(
                                                        errorText:
                                                            snapshot.hasError
                                                                ? snapshot.error
                                                                : null,
                                                        errorStyle: kBoldTextStyle
                                                            .copyWith(
                                                                fontSize:
                                                                    FontSize
                                                                        .s25),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelStyle: kBoldTextStyle
                                                            .copyWith(
                                                                fontSize:
                                                                    FontSize
                                                                        .s30)),
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    onChanged: (cmt) {
                                                      _comment = cmt;
                                                    },
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: <Widget>[
                                                  // Button Add
                                                  //TODO: Save Button
                                                  Expanded(
                                                    child: CusRaisedButton(
                                                      title: 'Thêm',
                                                      isDisablePress: true,
                                                      onPress: () {
                                                        StorageUtil
                                                                .getUserInfo()
                                                            .then((user) async {
                                                          String username =
                                                              user.fullName;
                                                          bool result = await _controller
                                                              .onComment(
                                                                  productId: widget
                                                                      .productId,
                                                                  comment:
                                                                      _comment,
                                                                  ratingPoint:
                                                                      _ratingPoint,
                                                                  username:
                                                                      username);
                                                          if (result) {
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        });
                                                      },
                                                      backgroundColor:
                                                          kColorBlack,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: ConstScreen
                                                        .setSizeWidth(20),
                                                  ),
                                                  // Button Add
                                                  Expanded(
                                                    child: CusRaisedButton(
                                                      title: 'Hủy',
                                                      onPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                      backgroundColor:
                                                          kColorLightGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            Navigator.pushNamed(context, 'register_screen');
                          }
                        }),
                  )
                ],
              ),
            ),
          ),

          // TODO: BOTTOM
          Expanded(
            flex: 9,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Comments')
                    .orderBy('create_at')
                    .where('product_id', isEqualTo: widget.productId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    //TODO: set
                    double totalReview = 0;
                    // snapshot.data.documents.length.toDouble();
                    double ratingPoint = 0;

                    for (var rating in snapshot.data.docs) {
                      if (rating['type'] == 'customer') {
                        totalReview++;
                        ratingPoint += rating['point'];
                      }
                    }
                    _controller.setTotalReview(totalReview.toInt());
                    _controller.setAveragePoint(ratingPoint / totalReview);
                    commentList =
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return RatingComment(
                        username: document['name'],
                        isAdmin: (document['type'] == 'admin'),
                        comment: document['comment'],
                        ratingPoint: document['point'],
                        createAt:
                            Util.convertDateToFullString(document['create_at']),
                        isCanDelete: widget.isAdmin,
                        onDelete: () {
                          FirebaseFirestore.instance
                              .collection('Comments')
                              .doc(document.id)
                              .delete();
                          setState(() {});
                        },
                      );
                    }).toList();
                    return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: commentList.reversed.toList());
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
