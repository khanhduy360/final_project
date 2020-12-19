import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';

import 'Detail/detail_user_profile_views.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String uid = 'ziplhAd2PYZeesSIpWb0aoTX1tt2';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Container(
      color: kColorWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //TODO: Detail
          CusRaisedButton(
            title: 'Thông tin chi tiết',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailProfileView(
                            uid: uid,
                          )));
            },
          ),
          //TODO: Change password
          CusRaisedButton(
            title: 'Đổi mật khẩu',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'customer_change_password_screen');
            },
          ),
          //TODO: Order and bill
          CusRaisedButton(
            title: 'Lịch sử đặt hàng',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'customer_order_history_screen');
            },
          ),
          //TODO: Bank Account
          CusRaisedButton(
            title: 'Tài khoản ngân hàng',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'custommer_bank_account_screen');
            },
          ),
          // TODO: Sign Out
          CusRaisedButton(
            title: 'Đăng xuất',
            backgroundColor: kColorRed,
            height: 100,
            onPress: () {
              StorageUtil.clear();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'welcome_screen', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
