import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/size_box_component.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputNormal extends StatefulWidget {
  InputNormal(
      {this.onFocus = false,
      this.labelText,
      this.labelIcon,
      this.children,
      this.isRequired = false,
      this.textError = '',
      this.isDropdown = false,
      this.focusBorder = false,
      this.onTap});

  final String labelText;
  final IconData labelIcon;
  final Widget children;
  final String textError;
  final bool onFocus;
  final bool isDropdown;
  final bool isRequired;
  bool focusBorder;
  final Function onTap;

  @override
  _InputNormalState createState() => _InputNormalState();
}

class _InputNormalState extends State<InputNormal> {
  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 375.0;
    double defaultScreenHeight = 812.0;
    ScreenUtil().setWidth(defaultScreenWidth);
    ScreenUtil().setHeight(defaultScreenHeight);
    Widget errorExpand = widget.textError != null
        ? Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.textError,
              maxLines: 2,
              style: TextStyle(
                  color: kColorRed,
                  fontSize: setFontSize(size: 12),
                  height: 1.4),
            ),
          )
        : null;
    Widget labelContent = Positioned(
      top: 0,
      left: 20,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: widget.isRequired ? 0 : 7),
        child: Row(
          children: <Widget>[
            widget.isRequired
                ? Icon(
                    Icons.brightness_1,
                    color: kColorOrange,
                    size: 9,
                  )
                : Container(),
            SizeBoxWidth(size: 5),
            Text(
              widget.labelText != null ? widget.labelText : '',
              style: TextStyle(
                height: 1.7,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                backgroundColor: Colors.white,
                color: kColorBody,
              ),
            ),
          ],
        ),
      ),
    );
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  height: 60,
                ),
              ),
              Positioned(
                top: 10,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.only(
                      left: 30, right: widget.isDropdown ? 25 : 5),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color:
                          widget.textError != '' ? kColorRed : kColorLightGrey,
                      width: 1.0,
                    ),
                  ),
                  child: widget.children,
                ),
              ),
              widget.labelText != null ? labelContent : null,
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            constraints: BoxConstraints(minHeight: 20.0),
            child: errorExpand,
          )
        ],
      ),
    );
  }
}
