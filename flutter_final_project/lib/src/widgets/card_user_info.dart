import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

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
              vertical: ConstScreen.setSizeHeight(10),
              horizontal: ConstScreen.setSizeWidth(10)),
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
                      isAdmin ? 'ADMIN' : 'CUSTOMER',
                      style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.setTextSize(32),
                        color: kColorWhite,
                      ),
                    ),
                  ),
                ),
              ),
              //TODO: id
              TitleWidget(
                title: 'ID',
                content: id,
                isSpaceBetween: false,
              ),
              //TODO: Username
              TitleWidget(
                title: 'Username',
                content: username,
                isSpaceBetween: false,
              ),
              //TODO: full name
              TitleWidget(
                title: 'Full name',
                content: fullname,
                isSpaceBetween: false,
              ),
              //TODO: phone number
              TitleWidget(
                title: 'Phone number',
                content: phone,
                isSpaceBetween: false,
              ),
              //TODO: Create at
              TitleWidget(
                title: 'Create at',
                content: createAt,
                isSpaceBetween: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
