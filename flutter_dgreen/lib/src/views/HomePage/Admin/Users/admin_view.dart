import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/chat_view.dart';
import 'package:flutter_dgreen/src/widgets/card_user_info.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminUserListView extends StatefulWidget {
  @override
  _AdminUserListViewState createState() => _AdminUserListViewState();
}

class _AdminUserListViewState extends State<AdminUserListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .orderBy('create_at')
            .where('type', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            int index = 0;
            return ListView(
              children: snapshot.data.docs
                  .map((DocumentSnapshot document) {
                    index++;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Chat',
                          color: kColorBlue,
                          icon: Icons.chat,
                          onTap: () {
                            //TODO: CHAT
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          isAdmin: true,
                                          uidCustomer: document.id,
                                        )));
                          },
                        ),
                      ],
                      child: UserInfoCard(
                          id: index.toString(),
                          username: document['username'],
                          fullname: document['fullname'],
                          phone: document['phone'],
                          isAdmin: true,
                          createAt: Util.convertDateToFullString(
                              document['create_at'])),
                    );
                  })
                  .toList()
                  .reversed
                  .toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
