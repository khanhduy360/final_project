import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/button_normal.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/button_social_auth.dart';

import 'SignIn/sign_in_form.dart';
import 'SignUp/sign_up_form.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSignIn = true;
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorGreen,
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.green,
              Colors.lightGreenAccent,
            ], begin: Alignment.topCenter),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ConstScreen.setSizeHeight(50),
                        horizontal: ConstScreen.setSizeHeight(50)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            _isSignIn ? 'Sign In' : 'Register',
                            style: TextStyle(
                                fontSize: FontSize.setTextSize(60),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _isSignIn
                              ? SignInView()
                              : SignUpView(
                                  typeAccount: 'customer',
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          //TODO: Button Change SignIn <-> SignUp
                          ButtonNormal(
                            // hasSuffixIcon: true,
                            isBtnColor: false,
                            text: _isSignIn ? 'REGISTER' : 'SIGN IN',
                            onPress: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                              });
                            },
                          ),
                          SizedBox(height: setHeightSize(size: 25)),
                          RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              style: new TextStyle(
                                fontSize: setFontSize(size: 14.0),
                                height: 1.5,
                                fontFamily: kFontMontserrat,
                                color: kColorGrey,
                              ),
                              children: [
                                new TextSpan(
                                  text: 'Hoặc đăng ký với',
                                ),
                                WidgetSpan(
                                    child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: kColorGrey,
                                  size: setFontSize(size: 16.0),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(height: setHeightSize(size: 10)),
                          SizedBox(height: setHeightSize(size: 10)),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ButtonSocialAuth(
                                  onPress: () {},
                                ),
                              ),
                              SizedBox(width: setWidthSize(size: 10)),
                              Expanded(
                                child: ButtonSocialAuth(
                                  isFacebook: true,
                                  onPress: () {},
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
