import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/widgets/input_normal.dart';

class DropdownCustom extends StatelessWidget {
  DropdownCustom(
      {@required this.listItem,
      this.itemSelected,
      this.iconSize = 14,
      this.hintText,
      this.isRequired = false,
      this.textError = '',
      this.onChanged,
      this.icon,
      this.labelText});

  final List<String> listItem;
  final String itemSelected;
  final String hintText;
  final String textError;
  final String labelText;
  final bool isRequired;
  final Icon icon;
  final double iconSize;
  final Function onChanged;

  DropdownButton<String> genderDestinationDropdown(BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String item in listItem) {
      var newItem = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      isExpanded: true,
      value: itemSelected,
      underline: SizedBox(),
      hint: itemSelected == null ? Text(hintText) : null,
      items: dropdownItems,
      icon: icon,
      iconSize: iconSize,
      style: TextStyle(
        color: itemSelected == null ? kColorGrey : kColorGreen,
        fontFamily: kFontMontserrat,
        fontSize: 14,
        letterSpacing: 1,
      ),
      onChanged: (value) {
        onChanged(value);
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InputNormal(
          isRequired: isRequired,
          textError: textError,
          isDropdown: true,
          labelText: labelText,
          children: genderDestinationDropdown(context),
        ),
      ],
    );
  }
}
