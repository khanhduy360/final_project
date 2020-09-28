import 'package:flutter/material.dart';
import 'package:flutter_final_project/link.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';

class CustomBanner extends StatelessWidget {
  CustomBanner({this.title, this.description, this.onPress, this.image});

  final String title;
  final String description;
  final String image;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPress();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(KImageAddress + image),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: FontSize.setTextSize(85),
                  color: kColorWhite,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: FontSize.setTextSize(30),
                color: kColorWhite,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kColorWhite, width: 2)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ConstScreen.setSizeHeight(5),
                    horizontal: ConstScreen.setSizeHeight(60)),
                child: Text('View',
                    style: TextStyle(
                        fontSize: FontSize.setTextSize(40),
                        color: kColorWhite,
                        fontWeight: FontWeight.w900)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
