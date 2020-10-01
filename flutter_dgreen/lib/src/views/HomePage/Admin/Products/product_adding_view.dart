import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/model/categogy.dart';
import 'package:flutter_dgreen/src/model/clothingSize.dart';
import 'package:flutter_dgreen/src/views/HomePage/Admin/Products/product_manager_controller.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class ProductAddingView extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _ProductAddingViewState createState() => _ProductAddingViewState();
}

class _ProductAddingViewState extends State<ProductAddingView> {
  ProductManagerController _controller = new ProductManagerController();
  List<String> category = ['Clothings', 'Shoes', 'Accessories'];
  List<String> sizeType = ['None', 'Top', 'Bottom', 'Shoes'];
  int indexSubCategory = 1;
  int indexSizeType = 0;
  String mainCategory = 'Clothings';

  final _nameController = new TextEditingController();
  final _priceController = new TextEditingController();
  final _salePriceController = new TextEditingController();
  final _brandController = new TextEditingController();
  final _madeInController = new TextEditingController();
  final _quantityController = new TextEditingController();
  final _descriptionController = new TextEditingController();
  List<Asset> images = List<Asset>();
  String subCategory = 'Choosing Category';
  String sizeTypeValue = 'Choosing type';
  List<String> sizeList = [];
  List<String> colorList = [];

  //TODO: renew value
  void renewValue() {
    _nameController.clear();
    _priceController.clear();
    _salePriceController.clear();
    _brandController.clear();
    _madeInController.clear();
    _quantityController.clear();
    _descriptionController.clear();
    images.clear();
    sizeList.clear();
    colorList.clear();
    String subCategory = 'Choosing Category';
    String sizeTypeValue = 'Choosing type';
  }

  //TODO: Image product holder
  Widget imageGridView() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: EdgeInsets.all(ConstScreen.sizeDefault),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  //TODO: load multi image
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000000",
          actionBarTitle: "Pick Product Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {}
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  //TODO: get sub category
  List getSubCategory(int index) {
    List subCategoryList = [];
    switch (index) {
      case 0:
        break;
      case 1:
        subCategoryList = Category.Clothing;
        break;
      case 2:
        subCategoryList = Category.Shoes;
        break;
      case 3:
        subCategoryList = Category.Accessories;
        break;
    }
    return subCategoryList.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: kNormalTextStyle.copyWith(fontSize: FontSize.s28),
        ),
      );
    }).toList();
  }

  //TODO: get size type
  List<String> getSizeType(int index) {
    List<String> sizeTypeList = [];
    switch (index) {
      case 0:
        break;
      case 1:
        sizeTypeList = ClothingPickingList.TeeSize;
        break;
      case 2:
        sizeTypeList = ClothingPickingList.PantSize;
        break;
      case 3:
        sizeTypeList = ClothingPickingList.ShoesSize;
        break;
    }
    return sizeTypeList;
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adding Product',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: ConstScreen.setSizeHeight(40),
            horizontal: ConstScreen.setSizeWidth(20)),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            //TODO: Product name
            StreamBuilder(
              stream: _controller.productNameStream,
              builder: (context, snapshot) => InputText(
                title: 'Product Name',
                controller: _nameController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            //TODO: Image product
            Text(
              'Product Images:',
              style:
                  kBoldTextStyle.copyWith(fontSize: FontSize.setTextSize(34)),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            imageGridView(),
            RaisedButton(
              child: Text(
                "Pick images",
                style: kBoldTextStyle.copyWith(fontSize: FontSize.s25),
              ),
              onPressed: loadAssets,
            ),
            //TODO: Image Error
            StreamBuilder(
              stream: _controller.productImageStream,
              builder: (context, snapshot) => Center(
                  child: Text(
                snapshot.hasError ? 'Error: ' + snapshot.error : '',
                style: kBoldTextStyle.copyWith(
                    fontSize: FontSize.s28, color: kColorRed),
              )),
            ),

            //TODO: Category
            Row(
              children: <Widget>[
                //TODO: main category
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      mainCategory,
                      style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: category.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style:
                              kNormalTextStyle.copyWith(fontSize: FontSize.s28),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        mainCategory = value;
                        subCategory = 'Chossing Category';
                        switch (mainCategory) {
                          case 'Main Category':
                            indexSubCategory = 0;
                            break;
                          case 'Clothings':
                            indexSubCategory = 1;
                            break;
                          case 'Shoes':
                            indexSubCategory = 2;
                            break;
                          case 'Accessories':
                            indexSubCategory = 3;
                            break;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: ConstScreen.sizeMedium,
                ),
                //TODO: sub category
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      subCategory,
                      style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: getSubCategory(indexSubCategory),
                    onChanged: (value) {
                      setState(() {
                        subCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            //TODO: Category Error
            StreamBuilder(
              stream: _controller.categoryStream,
              builder: (context, snapshot) => Center(
                  child: Text(
                snapshot.hasError ? 'Error: ' + snapshot.error : '',
                style: kBoldTextStyle.copyWith(
                    fontSize: FontSize.s28, color: kColorRed),
              )),
            ),
            //TODO: Size type
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'Size Type Picker:',
                    style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                  ),
                ),
                //TODO: picker size type
                Expanded(
                  flex: 1,
                  child: DropdownButton(
                    isExpanded: true,
                    hint: AutoSizeText(
                      sizeTypeValue,
                      style: kBoldTextStyle.copyWith(fontSize: FontSize.s28),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                    items: sizeType.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style:
                              kNormalTextStyle.copyWith(fontSize: FontSize.s28),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        sizeTypeValue = value;
                        switch (sizeTypeValue) {
                          case 'None':
                            indexSizeType = 0;
                            break;
                          case 'Top':
                            indexSizeType = 1;
                            break;
                          case 'Bottom':
                            indexSizeType = 2;
                            break;
                          case 'Shoes':
                            indexSizeType = 3;
                            break;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
//            TODO Size & Color Group check
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TODO: Size
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Multi Size Picker',
                        style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                      ),
                      CheckboxGroup(
                          labelStyle:
                              kNormalTextStyle.copyWith(fontSize: FontSize.s28),
                          labels: getSizeType(indexSizeType),
                          onSelected: (List<String> checked) {
                            sizeList = checked;
                          }),
                      //TODO: Size Error
                      StreamBuilder(
                        stream: _controller.sizeListStream,
                        builder: (context, snapshot) => Center(
                            child: Text(
                          snapshot.hasError ? 'Error: ' + snapshot.error : '',
                          style: kBoldTextStyle.copyWith(
                              fontSize: FontSize.s25, color: kColorRed),
                        )),
                      ),
                    ],
                  ),
                ),
                // TODO: Color
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Multi Color Picker',
                        style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                      ),
                      CheckboxGroup(
                          labelStyle:
                              kNormalTextStyle.copyWith(fontSize: FontSize.s28),
                          labels: ClothingPickingList.ColorList,
                          onSelected: (List<String> checked) {
                            colorList = checked;
                          }),
                      //TODO: Color Error
                      StreamBuilder(
                        stream: _controller.colorListStream,
                        builder: (context, snapshot) => Center(
                            child: Text(
                          snapshot.hasError ? 'Error: ' + snapshot.error : '',
                          style: kBoldTextStyle.copyWith(
                              fontSize: FontSize.s25, color: kColorRed),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            //TODO: Price and Sale Price
            Row(
              children: <Widget>[
                //TODO: Price
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: _controller.priceStream,
                    builder: (context, snapshot) => InputText(
                      title: 'Price',
                      controller: _priceController,
                      errorText: snapshot.hasError ? snapshot.error : '',
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(
                  width: ConstScreen.setSizeWidth(20),
                ),
                //TODO: Sale Price
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                    stream: _controller.salePriceStream,
                    builder: (context, snapshot) => InputText(
                      title: 'Sale Price',
                      controller: _salePriceController,
                      errorText: snapshot.hasError ? snapshot.error : '',
                      inputType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            // TODO: Brand
            StreamBuilder(
              stream: _controller.brandStream,
              builder: (context, snapshot) => InputText(
                title: 'Brand',
                controller: _brandController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            //TODO: Made In
            StreamBuilder(
              stream: _controller.madeInStream,
              builder: (context, snapshot) => InputText(
                title: 'Made In',
                controller: _madeInController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            //TODO: Quantity
            StreamBuilder(
              stream: _controller.quantityStream,
              builder: (context, snapshot) => InputText(
                title: 'Quantity',
                controller: _quantityController,
                errorText: snapshot.hasError ? snapshot.error : '',
                inputType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            //TODO: Description
            StreamBuilder(
              stream: _controller.descriptionStream,
              builder: (context, snapshot) => TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  focusColor: Colors.black,
                  labelStyle: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                  errorText: snapshot.hasError ? snapshot.error : null,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      //TODO Add product
      bottomNavigationBar: StreamBuilder(
          stream: _controller.btnLoadingStream,
          builder: (context, snapshot) {
            return CusRaisedButton(
              title: 'Add Product',
              backgroundColor: kColorBlack,
              height: 100,
              isDisablePress: snapshot.hasData ? snapshot.data : true,
              onPress: () async {
                bool result = await _controller.onAddProduct(
                    productName: _nameController.text,
                    imageList: images,
                    category: subCategory,
                    sizeList: sizeList,
                    colorList: colorList,
                    price: _priceController.text,
                    salePrice: _salePriceController.text,
                    brand: _brandController.text,
                    madeIn: _madeInController.text,
                    quantity: _quantityController.text,
                    description: _descriptionController.text,
                    sizeType: sizeTypeValue);
                if (result) {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: kColorWhite,
                    content: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: kColorGreen,
                          size: ConstScreen.setSizeWidth(50),
                        ),
                        SizedBox(
                          width: ConstScreen.setSizeWidth(20),
                        ),
                        Expanded(
                          child: Text(
                            'Product has been adding.',
                            style:
                                kBoldTextStyle.copyWith(fontSize: FontSize.s28),
                          ),
                        )
                      ],
                    ),
                  ));
                  //TODO: renew Value
                  setState(() {
                    renewValue();
                  });
                } else {
                  widget._scaffoldKey.currentState.showSnackBar(SnackBar(
                    backgroundColor: kColorWhite,
                    content: Row(
                      children: <Widget>[
                        Icon(
                          Icons.error,
                          color: kColorRed,
                          size: ConstScreen.setSizeWidth(50),
                        ),
                        SizedBox(
                          width: ConstScreen.setSizeWidth(20),
                        ),
                        Expanded(
                          child: Text(
                            'Added error.',
                            style:
                                kBoldTextStyle.copyWith(fontSize: FontSize.s28),
                          ),
                        )
                      ],
                    ),
                  ));
                }
              },
            );
          }),
    );
  }
}
