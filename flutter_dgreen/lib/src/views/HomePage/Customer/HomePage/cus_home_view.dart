import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/widgets/banner.dart';
import 'package:flutter_dgreen/src/widgets/icon_instacop.dart';
import 'package:flutter_dgreen/src/widgets/offer_auto_play.dart';

import 'product_list_view.dart';

class CustomerHomePageView extends StatefulWidget {
  @override
  _CustomerHomePageViewState createState() => _CustomerHomePageViewState();
}

class _CustomerHomePageViewState extends State<CustomerHomePageView>
    with AutomaticKeepAliveClientMixin {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Stack(
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
            OfferBannerView(),
            CustomBanner(
              title: 'SALE',
              description:
                  'Discover this season\'s new collection built around',
              image: 'banner_10.jpg',
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
          child: IconInstacop(
            textSize: FontSize.setTextSize(60),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
