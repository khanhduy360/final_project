import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/size_box_component.dart';
import 'package:flutter_dgreen/src/component/textline_between.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

import 'widget_title.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    Key key,
    this.id,
    this.isAdmin = false,
    this.username = '',
    this.fullname = '',
    this.phone = '',
    this.createAt = '',
  }) : super(key: key);
  final String id;
  final String fullname;
  final String username;
  final String phone;
  final String createAt;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ConstScreen.setSizeHeight(5),
          horizontal: ConstScreen.setSizeWidth(10)),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: ConstScreen.setSizeHeight(30),
              horizontal: ConstScreen.setSizeWidth(20)),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                color: isAdmin ? Colors.red[200] : Colors.lightBlueAccent,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ConstScreen.setSizeHeight(10)),
                    child: Text(
                      isAdmin ? 'Quản lý' : 'Khách hàng',
                      style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.setTextSize(32),
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizeBoxHeight(size: 30),
              //TODO: id
              TextLineBetween(
                label: 'ID',
                content: id,
              ),
              //TODO: Username
              TextLineBetween(
                label: 'Tên người dùng',
                content: username,
              ),
              //TODO: full name
              TextLineBetween(
                label: 'Họ tên',
                content: fullname,
              ),
              //TODO: phone number
              TextLineBetween(
                label: 'Phone',
                content: phone,
              ),
              //TODO: Create at
              TextLineBetween(
                label: 'Ngày tạo',
                content: createAt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
