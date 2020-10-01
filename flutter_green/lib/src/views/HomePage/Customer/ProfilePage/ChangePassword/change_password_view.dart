import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/TextStyle.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';
import 'package:flutter_green/src/widgets/button_raised.dart';
import 'package:flutter_green/src/widgets/input_text.dart';

import 'change_password_controller.dart';

class ChangePasswordView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();
  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  ChangePwdController _controller = new ChangePwdController();
  String currentPwd;
  String newPwd;
  String confirmPwd;
  bool isBtnLoading = true;
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change My Password',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ConstScreen.setSizeWidth(40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: ConstScreen.setSizeHeight(60),
            ),
            //TODO: Current password
            StreamBuilder(
                stream: _controller.currentPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'Current password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      currentPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: ConstScreen.setSizeHeight(13),
            ),
            //TODO: New password
            StreamBuilder(
                stream: _controller.newPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'New password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      newPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: ConstScreen.setSizeHeight(13),
            ),
            //TODO: Confirm new password
            StreamBuilder(
                stream: _controller.confirmPwdStream,
                builder: (context, snapshot) {
                  return InputText(
                    title: 'Confirm new password',
                    errorText: snapshot.hasError ? snapshot.error : '',
                    isPassword: true,
                    onValueChange: (value) {
                      confirmPwd = value;
                    },
                  );
                }),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
            //TODO: Change password Button
            StreamBuilder(
                stream: _controller.btnLoadingStream,
                builder: (context, snapshot) {
                  return CusRaisedButton(
                    title: 'Save',
                    backgroundColor: kColorBlack,
                    isDisablePress: snapshot.hasData ? snapshot.data : true,
                    onPress: () async {
                      setState(() {
                        isBtnLoading = false;
                      });
                      bool result = await _controller.onChangePwd(
                          currentPwd: currentPwd,
                          newPwd: newPwd,
                          confirmPwd: confirmPwd);
                      print(result);
                      if (result) {
                        setState(() {
                          isBtnLoading = true;
                        });
                        widget._globalKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: kColorWhite,
                          content: Row(
                            children: <Widget>[
                              Icon(
                                Icons.check,
                                color: kColorGreen,
                                size: ConstScreen.setSizeWidth(50),
                              ),
                              SizedBox(
                                width: ConstScreen.setSizeWidth(20),
                              ),
                              Expanded(
                                child: Text(
                                  'Your password has been changed.',
                                  style: kBoldTextStyle.copyWith(
                                      fontSize: FontSize.s28),
                                ),
                              )
                            ],
                          ),
                        ));
                      } else {
                        setState(() {
                          isBtnLoading = true;
                        });
                        widget._globalKey.currentState.showSnackBar(SnackBar(
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
                                  'Changed error.',
                                  style: kBoldTextStyle.copyWith(
                                      fontSize: FontSize.s28),
                                ),
                              )
                            ],
                          ),
                        ));
                      }
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
