import 'package:flutter/material.dart';
import 'package:flutter_green/src/helpers/screen.dart';
import 'package:flutter_green/src/helpers/shared_preferrence.dart';
import 'package:flutter_green/src/widgets/icon_instacop.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    delay().then((viewLink) {
      Navigator.pushNamed(context, viewLink);
    });
  }

  Future<String> delay() async {
    String viewLink = 'welcome_screen';
    StorageUtil.getIsLogging().then((result) async {
      if (result == null) {
        viewLink = 'welcome_screen';
      } else {
        String type = await StorageUtil.getAccountType();
        if (type == 'admin') {
          viewLink = 'admin_home_screen';
        } else {
          viewLink = 'customer_home_screen';
        }
      }
    });
    await Future.delayed(Duration(seconds: 3));

    return viewLink;
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.orange.shade900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconInstacop(
                textSize: FontSize.setTextSize(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
