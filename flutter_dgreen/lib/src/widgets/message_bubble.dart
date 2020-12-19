import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/ProductDetail/image_product_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender,
      this.text = '',
      this.isMe,
      this.isAdmin,
      this.onlineImagesList,
      this.documentID,
      this.createAt,
      this.uid,
      this.context});

  final String sender;
  final String text;
  final bool isMe;
  final List<dynamic> onlineImagesList;
  final String documentID;
  final String uid;
  final int createAt;
  final BuildContext context;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: (isMe && isDeleteMessage(createAt))
            ? <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: kColorRed,
                  icon: Icons.delete,
                  onTap: () {
                    //TODO: delete message
                    isDeleteMessage(createAt) {
                      FirebaseFirestore.instance
                          .collection('Chat')
                          .doc(uid)
                          .collection(uid)
                          .doc(documentID)
                          .delete();
                    }

                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: kColorWhite,
                      content: Row(
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: kColorRed,
                            size: ConstScreen.setSizeWidth(50),
                          ),
                          SizedBox(
                            width: ConstScreen.setSizeWidth(20),
                          ),
                          Expanded(
                            child: Text(
                              'Timeout to delete message.',
                              style: kBoldTextStyle.copyWith(
                                  fontSize: FontSize.s28),
                            ),
                          )
                        ],
                      ),
                    ));
                  },
                ),
              ]
            : null,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender,
              style: TextStyle(
                  fontSize: FontSize.s26,
                  fontWeight: FontWeight.bold,
                  color: isAdmin ? Colors.redAccent.shade400 : kColorGreen),
            ),
            (text != '')
                ? Material(
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                    elevation: 5.0,
                    color: isMe ? kColorGreen : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ConstScreen.setSizeHeight(15),
                          horizontal: ConstScreen.setSizeWidth(25)),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isMe ? Colors.white : kColorBlack,
                          fontSize: FontSize.s25,
                        ),
                      ),
                    ),
                  )
                : Container(),
            //TODO Image
            isMeListImage(),
          ],
        ),
      ),
    );
  }

  //TODO: check delete time
  bool isDeleteMessage(int createAt) {
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    int result = timeNow - createAt;
    print(result);
    return (result < 60000);
  }

  isMeListImage() {
    if (isMe) {
      return Row(
        children: <Widget>[
          Expanded(flex: 1, child: Container()),
          Expanded(flex: 2, child: getImageList()),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(flex: 2, child: getImageList()),
          Expanded(flex: 1, child: Container()),
        ],
      );
    }
  }

  //TODO load image list
  Widget getImageList() {
    if (onlineImagesList == null || onlineImagesList.length == 0) {
      return Container();
    } else {
      return GridView.count(
        crossAxisCount: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(onlineImagesList.length, (index) {
          String image = onlineImagesList[index];
          return Padding(
            padding: EdgeInsets.all(ConstScreen.setSizeHeight(5)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageProductView(
                              onlineImage: image,
                            )));
              },
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        }),
      );
    }
  }
}
