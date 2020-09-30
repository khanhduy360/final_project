import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';
import 'package:flutter_final_project/src/widgets/button_raised.dart';

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
                        vertical: ConstScreen.setSizeHeight(65),
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
                            height: 20,
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
                          CusRaisedButton(
                            backgroundColor: Colors.grey.shade100,
                            title: _isSignIn ? 'REGISTER' : 'SIGN IN',
                            onPress: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                              });
                            },
                          )
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
