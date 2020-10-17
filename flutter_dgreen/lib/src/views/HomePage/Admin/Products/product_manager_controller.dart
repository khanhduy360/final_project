import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dgreen/src/model/clothingSize.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductManagerController {
  StreamController _productNameController = new StreamController.broadcast();
  StreamController _productImageController = new StreamController.broadcast();
  StreamController _categoryController = new StreamController.broadcast();
  StreamController _sizeListController = new StreamController.broadcast();
  StreamController _colorListController = new StreamController.broadcast();
  StreamController _priceController = new StreamController.broadcast();
  StreamController _salePriceController = new StreamController.broadcast();
  StreamController _brandController = new StreamController.broadcast();
  StreamController _madeInController = new StreamController.broadcast();
  StreamController _quantityController = new StreamController.broadcast();
  StreamController _descriptionController = new StreamController.broadcast();
  StreamController _btnLoadingController = new StreamController.broadcast();

  Stream get productNameStream => _productNameController.stream;
  Stream get productImageStream => _productImageController.stream;
  Stream get categoryStream => _categoryController.stream;
  Stream get sizeListStream => _sizeListController.stream;
  Stream get colorListStream => _colorListController.stream;
  Stream get priceStream => _priceController.stream;
  Stream get salePriceStream => _salePriceController.stream;
  Stream get brandStream => _brandController.stream;
  Stream get madeInStream => _madeInController.stream;
  Stream get quantityStream => _quantityController.stream;
  Stream get descriptionStream => _descriptionController.stream;
  Stream get btnLoadingStream => _btnLoadingController.stream;

  onAddProduct(
      {@required String productName,
      @required List<Asset> imageList,
      @required String category,
      @required List<String> sizeList,
      @required List<String> colorList,
      @required String price,
      String salePrice = '0',
      @required String brand,
      @required String madeIn,
      @required String quantity,
      @required String description,
      @required String sizeType}) async {
    _productNameController.sink.add('');
    _productImageController.sink.add('');
    _categoryController.sink.add('');
    _sizeListController.sink.add('');
    _colorListController.sink.add('');
    _priceController.sink.add('');
    _salePriceController.sink.add('');
    _brandController.sink.add('');
    _madeInController.sink.add('');
    _quantityController.sink.add('');
    _descriptionController.sink.add('');
    int countError = 0;
    _btnLoadingController.sink.add(false);
    //TODO: Product name
    if (productName == null || productName == '') {
      _productNameController.addError('Product name is empty');
      countError++;
    }
    //TODO: Image list
    if (imageList.length == 0) {
      _productNameController.addError('Product images is empty');
      countError++;
    }
    //TODO: Category
    if (category == 'Sub Category') {
      _categoryController.sink.addError('Category is empty');
      countError++;
    }
    //TODO: Size list
    if (sizeType != 'None' && sizeList.length == 0) {
      _sizeListController.sink.addError('Size List is empty.');
      countError++;
    }
    //TODO: Color list
    if (colorList.length == 0) {
      _colorListController.addError('Product Colors is empty');
      countError++;
    }
    //TODO: Price
    if (price == null || price == '') {
      _priceController.addError('Product name is empty');
      countError++;
    }
    //TODO: Sale price
    if (salePrice == null || salePrice == '') {
//      _salePriceController.addError('Price is empty');
//      countError++;
      salePrice = '0';
    }
    //TODO: Brand
    if (brand == null || brand == '') {
      _brandController.addError('Brand is empty');
      countError++;
    }
    //TODO: Made in
    if (madeIn == null || madeIn == '') {
      _madeInController.addError('Made in is empty');
      countError++;
    }
    //TODO: Quantity
    if (quantity == null || quantity == '' || quantity == '0') {
      _quantityController.addError('Quantity is empty');
      countError++;
    }
    //TODO: Description
    if (description == null || description == '') {
      _descriptionController.addError('Description is empty');
      countError++;
    }

    //TODO: Add product
    if (countError == 0) {
      List<int> colorListFinal = convertListColor(colorList);
      List<String> linkImage = await saveImage(imageList);
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      print(linkImage.length);
      FirebaseFirestore.instance.collection('Products').doc(id).set({
        'id': id,
        'name': productName,
        'search_key': productName.substring(0, 1).toUpperCase(),
        'image': linkImage,
        'categogy': category,
        'size': sizeList,
        'color': colorListFinal,
        'price': price,
        'sale_price': salePrice,
        'brand': brand,
        'made_in': madeIn,
        'quantity': quantity,
        'description': description,
        'rating': 0.0,
        'create_at': DateTime.now().toString()
      }).catchError((onError) {
        print(onError.toString());
      });
      //TODO: Price Volatility
      FirebaseFirestore.instance.collection('PriceVolatility').doc().set({
        'product_id': id,
        'price': price,
        'sale_price': salePrice,
        'create_at': DateTime.now().toString(),
        'timeCreate': DateTime.now().millisecondsSinceEpoch
      });

      _btnLoadingController.sink.add(true);
      return true;
    }
    _btnLoadingController.sink.add(true);
    return false;
  }

  //TODO: Convert String to color type
  List<int> convertListColor(List<String> colorList) {
    List<int> result = [];
    for (var value in colorList) {
      result.add(ClothingPickingList().getColorFromColorList(value).value);
    }
    return result;
  }

  //TODO Save Image to Firebase Storage
  Future saveImage(List<Asset> asset) async {
    UploadTask uploadTask;
    List<String> linkImage = [];
    for (var value in asset) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
//      int width = 500;
//      int height = ((width * value.originalHeight) / width).round();
      ByteData byteData = await value.getByteData(quality: 70);
      var imageData = byteData.buffer.asUint8List();
      uploadTask = ref.putData(imageData);
      String imageUrl;
      await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL()
          .then((onValue) {
        imageUrl = onValue;
      });
      linkImage.add(imageUrl);
    }
    return linkImage;
  }

  void dispose() {
    _productNameController.close();
    _productImageController.close();
    _categoryController.close();
    _sizeListController.close();
    _colorListController.close();
    _priceController.close();
    _salePriceController.close();
    _brandController.close();
    _madeInController.close();
    _quantityController.close();
    _descriptionController.close();
    _btnLoadingController.close();
  }
}
