import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/style_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/widgets/button_normal.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/input_normal.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';

import 'sign_up_controller.dart';

class SignUpView extends StatefulWidget {
  SignUpView({this.typeAccount});
  final String typeAccount;
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<String> gender = ['Male', 'Female'];
  String genderData = 'Choose Gender';

  bool _isRegisterLoading = true;
  SignUpController signUpController = new SignUpController();

  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPwd = '';
  bool obscureText = true;
  bool isLoading = false;
  bool focusBorder = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // TODO: Full Name
        StreamBuilder(
          stream: signUpController.fullNameStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.person_outline),
            title: 'Full Name',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _fullName = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: phone number
        StreamBuilder(
          stream: signUpController.phoneStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.phone_android),
            title: 'Phone number',
            inputType: TextInputType.number,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _phone = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: email
        StreamBuilder(
          stream: signUpController.emailStream,
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
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: Password
        StreamBuilder(
          stream: signUpController.passwordStream,
          builder: (context, snapshot) => InputText(
            title: 'Password',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: Confirm Password
        StreamBuilder(
          stream: signUpController.confirmPwdSteam,
          builder: (context, snapshot) => InputText(
            title: 'Confirm',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _confirmPwd = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(25),
        ),

        StreamBuilder(
            stream: signUpController.btnLoadingStream,
            builder: (context, snapshot) {
              return ButtonNormal(
                isLoading: isLoading,
                // hasSuffixIcon: true,
                isBtnColor: true,
                text: 'REGISTER',
                onPress: () async {
                  bool result = await signUpController.onSubmitRegister(
                      fullName: _fullName,
                      phone: _phone,
                      email: _email,
                      password: _password,
                      confirmPwd: _confirmPwd,
                      typeAccount: widget.typeAccount);

                  if (result) {
                    if (widget.typeAccount == 'customer') {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
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
                                'Adding User Complete',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: FontSize.s28),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
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
                              'Sign Up failed.',
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
