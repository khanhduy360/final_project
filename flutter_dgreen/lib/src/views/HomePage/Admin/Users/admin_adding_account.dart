import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/views/Register/SignUp/sign_up_form.dart';

class AdminAddingAccount extends StatefulWidget {
  @override
  _AdminAddingAccountState createState() => _AdminAddingAccountState();
}

class _AdminAddingAccountState extends State<AdminAddingAccount> {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kColorGreen),
        backgroundColor: kColorWhite,
        // TODO: Quantity Items
        title: Text(
          'Thêm người dùng',
          style: TextStyle(
              color: kColorGreen,
              fontSize: FontSize.setTextSize(32),
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: ConstScreen.setSizeHeight(65),
                horizontal: ConstScreen.setSizeHeight(50)),
            child: SignUpView(
              typeAccount: 'admin',
            ),
          ),
        ),
      ),
    );
  }
}
