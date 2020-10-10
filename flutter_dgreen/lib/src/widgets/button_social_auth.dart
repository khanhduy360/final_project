import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class ButtonSocialAuth extends StatelessWidget {
  const ButtonSocialAuth({
    @required this.onPress,
    this.isFacebook = false,
  });

  final Function onPress;
  final bool isFacebook;

  @override
  Widget build(BuildContext context) {
    IconData prefixIcon = isFacebook ? DGreenIcon.facebook : DGreenIcon.google;
    return MaterialButton(
      color: isFacebook ? kColorFacebook : kColorRed,
      elevation: 0,
      onPressed: onPress,
      minWidth: double.infinity,
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            prefixIcon,
            color: Colors.white,
            size: setFontSize(size: 20),
          ),
          SizedBox(width: 10),
          Text(
            isFacebook ? 'Facebook' : 'Google',
            style: TextStyle(
              color: Colors.white,
              fontSize: setHeightSize(size: 16),
              fontFamily: kFontMontserratBold,
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
