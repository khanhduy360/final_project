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
  List<String> category = ['Trong nhà', 'Ngoài trời', 'Chậu treo'];
  int indexSubCategory = 1;
  int indexSizeType = 0;
  String mainCategory = 'Trong nhà';

  final _nameController = new TextEditingController();
  final _priceController = new TextEditingController();
  final _salePriceController = new TextEditingController();
  final _brandController = new TextEditingController();
  final _madeInController = new TextEditingController();
  final _quantityController = new TextEditingController();
  final _descriptionController = new TextEditingController();
  List<Asset> images = List<Asset>();
  String subCategory = 'Chọn loại';
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
        subCategoryList = Category.InSide;
        break;
      case 2:
        subCategoryList = Category.OutSide;
        break;
      case 3:
        subCategoryList = Category.Handing;
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

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Thêm sản phẩm',
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
                title: 'Tên sản phẩm',
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
              'Hình ảnh sản phẩm:',
              style:
                  kBoldTextStyle.copyWith(fontSize: FontSize.setTextSize(34)),
            ),
            SizedBox(
              height: ConstScreen.sizeMedium,
            ),
            imageGridView(),
            RaisedButton(
              child: Text(
                "Chọn ảnh",
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
                        subCategory = 'Chọn loại cây';
                        switch (mainCategory) {
                          case 'Main Category':
                            indexSubCategory = 0;
                            break;
                          case 'Trong nhà':
                            indexSubCategory = 1;
                            break;
                          case 'Ngoài trời':
                            indexSubCategory = 2;
                            break;
                          case 'Chậu treo':
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
            SizedBox(
              height: ConstScreen.setSizeHeight(20),
            ),
//            TODO Size & Color Group check
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Chọn màu',
                        style: kBoldTextStyle.copyWith(fontSize: FontSize.s30),
                      ),
                      CheckboxGroup(
                          labelStyle:
                              kNormalTextStyle.copyWith(fontSize: FontSize.s28),
                          labels: TreePickingList.ColorList,
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
                      title: 'Giá',
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
                      title: 'Giá khuyến mãi',
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
                title: 'Thương hiệu',
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
                title: 'Xuất xứ',
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
                title: 'Số lượng',
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
                  labelText: 'Mô tả',
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
              title: 'Thêm sản phẩm',
              backgroundColor: kColorBlack,
              height: 100,
              isDisablePress: snapshot.hasData ? snapshot.data : true,
              onPress: () async {
                bool result = await _controller.onAddProduct(
                  productName: _nameController.text,
                  imageList: images,
                  category: subCategory,
                  colorList: colorList,
                  price: _priceController.text,
                  salePrice: _salePriceController.text,
                  brand: _brandController.text,
                  madeIn: _madeInController.text,
                  quantity: _quantityController.text,
                  description: _descriptionController.text,
                );
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
                            'Sản phẩm đã được thêm vào.',
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
