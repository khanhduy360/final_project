class Product {
  String id;
  String productName;
  List<dynamic> imageList;
  String category;
  List<dynamic> colorList;
  String price;
  String salePrice;
  String brand;
  String madeIn;
  String quantity;
  String quantityMain;
  String description;
  double rating;
  String image;
  String size;
  int color;
  Product(
      {this.id,
      this.productName,
      this.imageList,
      this.image,
      this.category,
      this.size,
      this.colorList,
      this.color,
      this.price,
      this.salePrice,
      this.brand,
      this.madeIn,
      this.quantity,
      this.quantityMain,
      this.description,
      this.rating});
}
