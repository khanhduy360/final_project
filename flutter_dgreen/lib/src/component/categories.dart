import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/product_list_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {"icon": "lib/src/assets/icons/Flash Icon.svg", "text": "Flash Sale"},
      {"icon": "lib/src/assets/icons/Bill Icon.svg", "text": "Hàng mới"},
      {"icon": "lib/src/assets/icons/Game Icon.svg", "text": "Trò chơi"},
      {"icon": "lib/src/assets/icons/Gift Icon.svg", "text": "Quà tặng"},
      {"icon": "lib/src/assets/icons/Discover.svg", "text": "Nhiều hơn"},
    ];
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductListView(
                            search: 'sale',
                          )));
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 55,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
