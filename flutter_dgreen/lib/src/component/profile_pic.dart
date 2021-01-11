import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/icon_notification.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/image_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/user.dart';
import 'package:photo_view/photo_view.dart';

class ProfileAvatar extends StatelessWidget {
  final UserApp userInfo;
  final Function notifyCallback;
  ProfileAvatar({this.userInfo, this.notifyCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: setWidthSize(size: 15), horizontal: setWidthSize(size: 25)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[_avatar(), _userInfo()],
      ),
    );
  }

  Widget _avatar() {
    String _avatarUrl = '';
    userInfo != null ? _avatarUrl = userInfo.avatar : "";

    return CircleAvatar(
      backgroundImage: _avatarUrl == ""
          ? AssetImage(kAvatarDefault)
          : NetworkImage(_avatarUrl),
      backgroundColor: Color(0xFFF89E1E),
      radius: setWidthSize(size: 100),
    );
  }

  Widget _userInfo() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: setWidthSize(size: 15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Xin Chào !',
              style: TextStyle(
                fontFamily: kFontMontserrat,
                color: kColorGreen,
                fontSize: setFontSize(size: 40),
                height: 1.5,
              ),
            ),
            Text(
              '${userInfo.fullName}',
              style: TextStyle(
                fontFamily: kFontMontserrat,
                color: kColorGreen,
                fontSize: setFontSize(size: 40),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
