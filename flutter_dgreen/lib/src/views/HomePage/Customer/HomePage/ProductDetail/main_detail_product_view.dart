import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/model/product.dart';

import 'ProductPage/product_page.dart';
import 'RatingPage/rating_product_page.dart';
import 'detail_product_page.dart';

class MainDetailProductView extends StatefulWidget {
  MainDetailProductView({this.product});
  final Product product;
  @override
  _MainDetailProductViewState createState() => _MainDetailProductViewState();
}

class _MainDetailProductViewState extends State<MainDetailProductView> {
  Product product;
  List<Widget> pages = [];
  final PageStorageBucket bucket = PageStorageBucket();
  final pageController = PageController();
  int indexPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    product = widget.product;
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);

    return Scaffold(
      body: SafeArea(
          child: PageStorage(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              indexPage = index;
            });
          },
          children: <Widget>[
            ProductPage(
              product: widget.product,
            ),
            DetailOfProductPage(
              product: widget.product,
            ),
            RatingProductPage(
              productId: widget.product.id,
              isAdmin: false,
            )
          ],
        ),
        bucket: bucket,
      )),
      bottomNavigationBar: SizedBox(
        height: ConstScreen.setSizeHeight(115),
        child: BottomNavigationBar(
          onTap: onTap,
          currentIndex: indexPage,
          unselectedFontSize: FontSize.s25,
          selectedFontSize: FontSize.s28,
          selectedItemColor: kColorBlack,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          iconSize: ConstScreen.setSizeHeight(0.1),
          items: const [
            BottomNavigationBarItem(
                title: Text('Product'), icon: Icon(Icons.rate_review)),
            BottomNavigationBarItem(
                title: Text('Detail'), icon: Icon(Icons.rate_review)),
            BottomNavigationBarItem(
                title: Text('Rating'), icon: Icon(Icons.rate_review)),
          ],
        ),
      ),
    );
  }
}
