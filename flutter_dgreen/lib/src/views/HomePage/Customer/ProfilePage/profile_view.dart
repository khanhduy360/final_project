import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/profile_menu.dart';
import 'package:flutter_dgreen/src/component/profile_pic.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/model/user.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Detail/detail_user_profile_views.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String uid = '';

  Future<UserApp> userApp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((onValue) {
      uid = onValue;
    });
    userApp = getUser();
  }

  Widget build(BuildContext context) => FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildWidget(snapshot.data) : Container(),
      );
  @override
  Widget _buildWidget(UserApp userApp) {
    ConstScreen.setScreen(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //TODO: Detail
          ProfileAvatar(
            userInfo: userApp,
          ),
          SizedBox(height: 20),
          ProfileMenu(
            text: "Thông tin tài khoản",
            icon: "lib/src/assets/icons/User Icon.svg",
            style: TextStyle(
                color: kColorGreen,
                fontSize: FontSize.setTextSize(32),
                fontFamily: kFontMontserrat),
            color: kColorGreen,
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailProfileView(
                            uid: uid,
                          )));
            },
          ),
          ProfileMenu(
            text: "Đổi mật khẩu",
            icon: "lib/src/assets/icons/changepass.svg",
            style: TextStyle(
                color: kColorGreen,
                fontSize: FontSize.setTextSize(32),
                fontFamily: kFontMontserrat),
            color: kColorGreen,
            press: () {
              Navigator.pushNamed(context, 'customer_change_password_screen');
            },
          ),
          ProfileMenu(
            text: "Lịch sử đơn hàng",
            icon: "lib/src/assets/icons/history.svg",
            style: TextStyle(
                color: kColorGreen,
                fontSize: FontSize.setTextSize(32),
                fontFamily: kFontMontserrat),
            color: kColorGreen,
            press: () {
              Navigator.pushNamed(context, 'customer_order_history_screen');
            },
          ),
          ProfileMenu(
            text: "Tài khoản ngân hàng",
            icon: "lib/src/assets/icons/bank.svg",
            style: TextStyle(
                color: kColorGreen,
                fontSize: FontSize.setTextSize(32),
                fontFamily: kFontMontserrat),
            color: kColorGreen,
            press: () {
              Navigator.pushNamed(context, 'custommer_bank_account_screen');
            },
          ),

          ProfileMenu(
            text: "Đăng xuất",
            style: TextStyle(
                color: kColorRed,
                fontSize: FontSize.setTextSize(32),
                fontFamily: kFontMontserrat),
            icon: "lib/src/assets/icons/Log out.svg",
            color: kColorRed,
            press: () {
              _onWillPop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  StorageUtil.clear();
                  Navigator.pushNamedAndRemoveUntil(context, 'welcome_screen',
                      (Route<dynamic> route) => false);
                },
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<UserApp> getUser() => Future.delayed(Duration(seconds: 1), () {
        userApp = StorageUtil.getUserInfo();
        return userApp;
      });
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
