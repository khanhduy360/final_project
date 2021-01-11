class Product {
  String id;
  String productName;
  List<dynamic> imageList;
  String category;
  List<dynamic> colorList;
  String price;
  String salePrice;

  String madeIn;
  String quantity;
  String quantityMain;
  String description;
  double rating;
  String image;
  int color;
  Product(
      {this.id,
      this.productName,
      this.imageList,
      this.image,
      this.category,
      this.colorList,
      this.color,
      this.price,
      this.salePrice,
      this.madeIn,
      this.quantity,
      this.quantityMain,
      this.description,
      this.rating});
}
