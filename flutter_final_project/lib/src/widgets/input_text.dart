import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

class InputText extends StatefulWidget {
  InputText({
    this.errorText,
    @required this.title,
    this.isPassword = false,
    this.isNumber = false,
    this.inputType = TextInputType.text,
    @required this.icon = null,
    this.onValueChange,
    this.hintText = '',
    this.controller,
  });
  final bool isNumber;
  final TextInputType inputType;
  final String errorText;
  final String title;
  final bool isPassword;
  final IconData icon;
  final Function onValueChange;
  final String hintText;
  final TextEditingController controller;
  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
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
    return TextField(
      autofocus: false,
      controller: widget.controller,
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
