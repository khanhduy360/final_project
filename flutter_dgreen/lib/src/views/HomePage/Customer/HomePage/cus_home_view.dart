import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/categories.dart';
import 'package:flutter_dgreen/src/component/special_offers.dart';
import 'package:flutter_dgreen/src/helpers/image_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/user.dart';
import 'package:flutter_dgreen/src/widgets/banner.dart';
import 'package:flutter_dgreen/src/widgets/header_widget.dart';
import 'package:flutter_dgreen/src/widgets/icon_instacop.dart';
import 'package:flutter_dgreen/src/widgets/offer_widget.dart';

import 'menu_widget.dart';
import 'product_list_view.dart';

class CustomerHomePageView extends StatefulWidget {
  @override
  _CustomerHomePageViewState createState() => _CustomerHomePageViewState();
}

class _CustomerHomePageViewState extends State<CustomerHomePageView>
    with AutomaticKeepAliveClientMixin {
  Future<String> uid;
  Future<UserApp> userApp;
  List<Map<String, dynamic>> _offer = [
    {
      'img': 'offer_1.png',
      'description': 'Cho 5 sản phẩm đầu tiên của bạn',
      'textBtn': 'Đặt ngay',
      'offer': 25
    },
    {
      'img': 'offer_2.png',
      'description':
          'Khi chia sẻ với bạn bè của bạn. Áp dụng khi chia sẻ với mọi người',
      'textBtn': 'Chia sẻ ngay',
      'offer': 20
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userApp = getUser();
    uid = getUserID();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: getUser(),
        builder: (context, snapshot) => snapshot.hasData
            ? _buildWidget(snapshot.data)
            : _buildGuest(context),
      );

  Widget _buildWidget(UserApp userApp) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: kColorOrange,
        // ),
        body: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            //TODO Background Header
            headerContent(context),
            SafeArea(
              child: Container(
                child: Column(
                  children: <Widget>[
                    HomeHeaderWidget(
                      userInfo: userApp,
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Categories(),
                          SpecialOffers(),
                          OfferList(
                            offer: _offer,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => exit(0),
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget _buildGuest(BuildContext context) {
    ConstScreen.setScreen(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Banner Slider
          CarouselSlider(
            options: CarouselOptions(
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.vertical,
              initialPage: 0,
            ),
            items: <Widget>[
              CustomBanner(
                title: 'Hàng mới',
                description:
                    'Khám phá các mặt hàng mới nhất của chúng tôi',
                image: 'banner1.png',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListView(
                                search: '',
                              )));
                },
              ),
              CustomBanner(
                title: 'Khuyến mãi',
                description:
                    'Cơ hội sở hữu nhiều sản phẩm có giá cực hot',
                image: 'baner.jpg',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListView(
                                search: 'sale',
                              )));
                },
              ),
            ],
          ),
          // Logo
          Positioned(
            top: 0,
            left: ConstScreen.setSizeWidth(255),
            child: IconDgreen(
              textSize: FontSize.setTextSize(60),
            ),
          ),
        ],
      ),
    );
  }

  Widget headerContent(BuildContext context) {
    double _height = MediaQuery.of(context).size.height * 1 / 3;
    double _width = MediaQuery.of(context).size.width * 2;
    return Container(
      child: Image.asset(
        kImgHeader,
        fit: BoxFit.fill,
        width: setWidthSize(size: _width),
        height: setHeightSize(size: _height),
      ),
      height: setHeightSize(size: _height),
    );
  }

  Future<UserApp> getUser() => Future.delayed(Duration(seconds: 1), () {
        userApp = StorageUtil.getUserInfo();
        return userApp;
      });
  Future<String> getUserID() => Future.delayed(Duration(seconds: 1), () {
        uid = StorageUtil.getUid();
        return uid;
      });

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
