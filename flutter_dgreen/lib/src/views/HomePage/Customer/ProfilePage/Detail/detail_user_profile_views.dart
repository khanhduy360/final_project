import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/widgets/widget_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_detail_views.dart';

class DetailProfileView extends StatefulWidget {
  DetailProfileView({this.uid});
  final String uid;
  @override
  _DetailProfileViewState createState() => _DetailProfileViewState();
}

class _DetailProfileViewState extends State<DetailProfileView> {
  DateTime birthDay;
  List<String> gender = ['Nam', 'Nữ'];

  //TODO: data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Thông tin chi tiết',
            style: kBoldTextStyle.copyWith(
              fontSize: FontSize.setTextSize(32),
            ),
          ),
          backgroundColor: kColorWhite,
          iconTheme: IconThemeData.fallback(),
          actions: <Widget>[
            IconButton(
              icon: Icon(FontAwesomeIcons.edit),
              color: kColorBlack,
              iconSize: ConstScreen.setSizeWidth(35),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditDetailView()));
              },
            )
          ],
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(
                top: ConstScreen.setSizeHeight(50),
                left: ConstScreen.setSizeWidth(30)),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TitleWidget(
                        title: 'Họ tên:',
                        content: snapshot.data['fullname'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Giới tính:',
                        content: snapshot.data['gender'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Số điện thoại:',
                        content: snapshot.data['phone'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Địa chỉ:',
                        content: snapshot.data['address'],
                        isSpaceBetween: false,
                      ),
                      TitleWidget(
                        title: 'Ngày sinh:',
                        content: snapshot.data['birthday'],
                        isSpaceBetween: false,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }
}
