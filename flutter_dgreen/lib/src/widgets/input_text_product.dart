import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class InputTextProduct extends StatefulWidget {
  InputTextProduct(
      {this.errorText,
      @required this.title,
      this.isPassword = false,
      this.isNumber = false,
      this.inputType = TextInputType.text,
      @required this.icon = null,
      this.onValueChange,
      this.hintText = '',
      this.controller,
      this.initValue = ' '});
  final bool isNumber;
  final TextInputType inputType;
  final String errorText;
  final String title;
  final bool isPassword;
  final IconData icon;
  final Function onValueChange;
  final String hintText;
  final TextEditingController controller;
  final String initValue;
  @override
  _InputTextProductState createState() => _InputTextProductState();
}

class _InputTextProductState extends State<InputTextProduct> {
  bool isShowPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isPassword) {
      isShowPassword = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return TextFormField(
      autofocus: false,
      controller: widget.controller,
      initialValue: widget.initValue,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: kBoldTextStyle.copyWith(
            fontSize: FontSize.s28, fontWeight: FontWeight.w200),
        labelText: widget.title,
        focusColor: Colors.black,
        labelStyle: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
        errorText: (widget.errorText == '') ? null : widget.errorText,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                child: Icon(isShowPassword
                    ? Icons.remove_red_eye
                    : Icons.visibility_off),
                onTap: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: (widget.errorText != '') ? kColorBlack : kColorRed),
        ),
      ),
      style: TextStyle(fontSize: FontSize.s28),
      obscureText: isShowPassword,
      keyboardType: widget.inputType,
      onChanged: (value) {
        widget.onValueChange(value);
      },
    );
  }
}
