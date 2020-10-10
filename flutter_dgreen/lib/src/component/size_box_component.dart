import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class SizeBoxHeight extends StatelessWidget {
  SizeBoxHeight({this.size = 5.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: setHeightSize(size: size));
  }
}

class SizeBoxWidth extends StatelessWidget {
  SizeBoxWidth({this.size = 5.0});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: setWidthSize(size: size));
  }
}
