import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/widgets/button_normal.dart';
import 'package:flutter_dgreen/src/widgets/button_tap.dart';
import 'package:flutter_dgreen/src/widgets/icon_instacop.dart';

import '../../link.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(KImageAddress + 'welcome.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.3),
                  Colors.black.withOpacity(.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(90)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: IconDgreen(
                      textSize: FontSize.setTextSize(150),
                    ),
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(100),
                  ),
                  new ButtonNormal(
                    text: 'Đăng nhập / Đăng kí',
                    isBtnColor: true,
                    onPress: () {
                      Navigator.pushNamed(context, 'register_screen');
                    },
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(25),
                  ),
                  new ButtonNormal(
                    text: "Khám phá",
                    onPress: () {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
