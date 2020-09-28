import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/views/HomePage/Customer/HomePage/ProductDetail/RatingPage/rating_product_page.dart';

class AdminProductCommentView extends StatefulWidget {
  AdminProductCommentView({this.productId});
  final String productId;
  @override
  _AdminProductCommentViewState createState() =>
      _AdminProductCommentViewState();
}

class _AdminProductCommentViewState extends State<AdminProductCommentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RatingProductPage(
          productId: widget.productId,
          isAdmin: true,
        ),
      ),
    );
  }
}
