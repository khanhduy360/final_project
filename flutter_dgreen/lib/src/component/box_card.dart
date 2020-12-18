/// [BoxCard] widget custom
/// [@required child widget]
///
/// Example:
///
/// ```dart
/// BoxCard(
///   child: Container(),
/// );
/// ```

import 'package:flutter/material.dart';

class BoxCard extends StatelessWidget {
  final Widget child;
  final double marginHorizontal;
  final double marginVertical;
  final EdgeInsets padding;

  const BoxCard({
    Key key,
    @required this.child,
    this.padding,
    this.marginVertical = 15,
    this.marginHorizontal = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? padding,
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal, vertical: marginVertical),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            offset: Offset(0, 3),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
