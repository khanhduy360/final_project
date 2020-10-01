import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';
import 'package:flutter_green/src/helpers/shared_preferrence.dart';
import 'package:flutter_green/src/widgets/button_raised.dart';

import 'Detail/detail_user_profile_views.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with AutomaticKeepAliveClientMixin {
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((onValue) {
      uid = onValue;
    });
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
            title: 'Detail',
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
            title: 'Change Password',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'customer_change_password_screen');
            },
          ),
          //TODO: Order and bill
          CusRaisedButton(
            title: 'Orders History',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'customer_order_history_screen');
            },
          ),
          //TODO: Bank Account
          CusRaisedButton(
            title: 'Bank Account',
            backgroundColor: kColorWhite,
            height: 100,
            onPress: () {
              Navigator.pushNamed(context, 'custommer_bank_account_screen');
            },
          ),
          // TODO: Sign Out
          CusRaisedButton(
            title: 'Sign out',
            backgroundColor: kColorBlack,
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
