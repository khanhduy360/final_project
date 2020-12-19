import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/image_constant.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/model/user.dart';
import 'package:flutter_dgreen/src/widgets/header_widget.dart';
import 'package:flutter_dgreen/src/widgets/offer_widget.dart';

import 'menu_widget.dart';

class CustomerHomePageView extends StatefulWidget {
  @override
  _CustomerHomePageViewState createState() => _CustomerHomePageViewState();
}

class _CustomerHomePageViewState extends State<CustomerHomePageView>
    with AutomaticKeepAliveClientMixin {
  Future<String> uid;
  Future<UserApp> userApp;
  List<ItemModel> _menus = [
    ItemModel(
      image: 'sale.png',
      title: 'Giảm giá',
    ),
    ItemModel(
      image: 'shipping.png',
      title: 'Free ship',
    ),
    ItemModel(
      image: 'sale.png',
      title: 'Giảm giá',
    ),
    ItemModel(
      image: 'sale.png',
      title: 'Giảm giá',
    ),
    ItemModel(
      image: 'sale.png',
      title: 'Giảm giá',
    ),
    ItemModel(
      image: 'sale.png',
      title: 'Giảm giá',
    ),
  ];
  List<Map<String, dynamic>> _offer = [
    {
      'img': 'offer1.png',
      'description': 'Cho 5 sản phẩm đầu tiên của bạn',
      'textBtn': 'Đặt ngay',
      'offer': 25
    },
    {
      'img': 'offer2.png',
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
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildWidget(snapshot.data) : const SizedBox(),
      );

  Widget _buildWidget(UserApp userApp) {
    return Scaffold(
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
                        MenuHomeWidget(menuList: _menus),
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
