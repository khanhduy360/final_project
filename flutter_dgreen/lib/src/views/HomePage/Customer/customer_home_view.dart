import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'HomePage/cus_home_view.dart';
import 'ProfilePage/profile_view.dart';
import 'SearchPage/search_view.dart';
import 'WishlistPage/wishlist_view.dart';
import 'chat_view.dart';

class CustomerHomeView extends StatefulWidget {
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  final tabsScreen = [
    CustomerHomePageView(),
    SearchView(),
    WishListView(),
    ChatScreen(),
    ProfileView(),
  ];
  final tabsTitle = [' ', 'Tìm kiếm', 'Yêu thích', 'Chat', 'Hồ sơ'];
  int indexScreen = 0;
  bool _isLogging;
  String isUid = '';
  final pageController = PageController();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  initState() {
    // TODO: implement initState

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: (indexScreen > 1)
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kColorWhite,
              iconTheme: IconThemeData.fallback(),
              title: Text(
                tabsTitle[indexScreen],
                style:
                    kBoldTextStyle.copyWith(fontSize: FontSize.setTextSize(32)),
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.shoppingBag,
                    color: kColorGreen,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'customer_cart_page');
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
          child: PageStorage(
        bucket: bucket,
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            if (!_isLogging && index > 1) {
              pageController.jumpToPage(--index);
            } else {
              setState(() {
                indexScreen = index;
              });
            }
          },
          children: tabsScreen,
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 1,
        unselectedFontSize: 1,
        selectedItemColor: kColorBlack,
        currentIndex: indexScreen,
        onTap: (index) {
          print('onTap ' + _isLogging.toString());
          if (_isLogging == false && index > 1) {
            Navigator.pushNamed(context, 'register_screen');
          } else {
            setState(() {
              pageController.jumpToPage(index);
              indexScreen = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: ConstScreen.sizeXXL,
                color: kColorGreen,
              ),
              title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.search,
                size: ConstScreen.sizeXL,
                color: kColorGreen,
              ),
              title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: ConstScreen.sizeXL,
                color: kColorRed,
              ),
              title: Text('Wishlist')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: ConstScreen.sizeXL,
                color: kColorBlue,
              ),
              title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: ConstScreen.sizeXL,
              ),
              title: Text('Profile')),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
