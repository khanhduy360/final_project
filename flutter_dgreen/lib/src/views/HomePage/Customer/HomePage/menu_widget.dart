import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/box_card.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/font_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/cus_home_view.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/SearchPage/search_view.dart';

class ItemModel {
  final String image;
  final String title;
  final String routeName;

  ItemModel({this.image, this.title, this.routeName});
}

class MenuHomeWidget extends StatefulWidget {
  MenuHomeWidget({this.menuList});

  final List<ItemModel> menuList;

  @override
  _MenuHomeWidgetState createState() => _MenuHomeWidgetState();
}

class _MenuHomeWidgetState extends State<MenuHomeWidget> {
  bool _isLoading = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // var global = Provider.of<GlobalProvider>(context, listen: false);
    return BoxCard(
      marginVertical: 10,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.menuList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          var _item = widget.menuList[index];
          return vehicleItemWidget(
            index,
            'lib/src/assets/images/${_item.image}',
            _item.title,
            onPressed: () async {
              //
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerHomePageView()),
              );
            },
          );
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Container(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: new AlwaysStoppedAnimation<Color>(kColorOrange),
        ),
      ),
    );
  }

  Widget _itemWidget(String imageAsset, String title) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imageAsset, height: 35),
          SizedBox(height: 4),
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            minFontSize: 10,
            style: TextStyle(
              fontFamily: kFontMontserratBold,
              color: Color(0xFF333333),
              fontSize: setFontSize(size: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget vehicleItemWidget(int index, String imageAsset, String title,
      {Function onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? null,
      child: _isLoading
          ? _index == index ? _loadingWidget() : _itemWidget(imageAsset, title)
          : _itemWidget(imageAsset, title),
    );
  }
}
