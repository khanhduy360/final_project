import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/colors_constant.dart';
import 'package:flutter_green/src/helpers/screen.dart';

class QuantityWidget extends StatelessWidget {
  QuantityWidget({this.value = 0, this.onChange});
  final int value;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // TODO: Quantity Down Button
        Container(
          height: ConstScreen.setSizeHeight(60),
          width: ConstScreen.setSizeHeight(80),
          decoration: BoxDecoration(
              border: Border.all(color: kColorBlack.withOpacity(0.6))),
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              iconSize: ConstScreen.setSizeWidth(25),
              onPressed: () {
                int _value = value;
                if (_value > 0) {
                  onChange(--_value);
                }
              },
            ),
          ),
        ),
        //TODO: Quantity value
        Container(
          height: ConstScreen.setSizeHeight(60),
          width: ConstScreen.setSizeHeight(200),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(color: kColorBlack.withOpacity(0.6)),
            bottom: BorderSide(color: kColorBlack.withOpacity(0.6)),
          )),
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(fontSize: FontSize.s28),
            ),
          ),
        ),
        // TODO: Quantity Up Button
        Container(
          height: ConstScreen.setSizeHeight(60),
          width: ConstScreen.setSizeHeight(80),
          decoration: BoxDecoration(
              border: Border.all(color: kColorBlack.withOpacity(0.6))),
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
              ),
              iconSize: ConstScreen.setSizeWidth(25),
              onPressed: () {
                int _value = value;
                onChange(++_value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
