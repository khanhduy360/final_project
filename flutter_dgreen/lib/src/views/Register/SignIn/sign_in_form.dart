import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/image_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/style_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/button_normal.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/input_normal.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';

import 'sign_in_controller.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool obscureText = true;
  bool _isAdmin = false;
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;
  SignInController signInController = new SignInController();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //TODO: Username
        StreamBuilder(
          stream: signInController.emailStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.mail),
            title: 'Email',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _email = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(18),
        ),
        //TODO: Password
        StreamBuilder(
          stream: signInController.passwordStream,
          builder: (context, snapshot) => InputText(
            title: 'Mật Khẩu',
            isPassword: true,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        //TODO: Button Sign In
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //TODO: Admin
            Expanded(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                height: ConstScreen.setSizeHeight(90),
                color: _isAdmin ? kColorOrange : kColorWhite,
                child: Text(
                  'Quản lý',
                  style: TextStyle(
                      color: _isAdmin ? kColorWhite : kColorOrange,
                      fontSize: FontSize.s30),
                ),
                onPressed: () {
                  setState(() {
                    _isAdmin = true;
                    print('Admin' + _isAdmin.toString());
                  });
                },
              ),
            ),
            //TODO: Customer
            Expanded(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                height: ConstScreen.setSizeHeight(90),
                color: _isAdmin ? kColorWhite : kColorOrange,
                child: Text(
                  'Khách Hàng',
                  style: TextStyle(
                      color: _isAdmin ? kColorOrange : kColorWhite,
                      fontSize: FontSize.s30),
                ),
                onPressed: () {
                  setState(() {
                    _isAdmin = false;
                    print('customer' + _isAdmin.toString());
                  });
                },
              ),
            ),
          ],
        ),

        SizedBox(
          height: ConstScreen.setSizeHeight(25),
        ),
        StreamBuilder(
            stream: signInController.btnLoadingStream,
            builder: (context, snapshot) {
              return ButtonNormal(
                // hasSuffixIcon: true,
                isBtnColor: true,
                text: 'ĐĂNG NHẬP',
                onPress: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  var result = await signInController.onSubmitSignIn(
                      email: _email, password: _password, isAdmin: _isAdmin);

                  print('Screen' + result.toString());

                  if (result != '') {
                    Navigator.pushNamed(context, result.toString());
                    SignInController().dispose();
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
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
                              'Đăng nhập thất bại.',
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
            }),
      ],
    );
  }
}
