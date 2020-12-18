import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/model/product.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/ProductDetail/main_detail_product_view.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/HomePage/product_list_view.dart';
import 'package:flutter_dgreen/src/widgets/card_product.dart';
import 'package:flutter_dgreen/src/widgets/category_item.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin {
  List queryResultSet = [];
  List tempSearchStore = [];
  bool isSearch = false;
  bool isVoiceSearch = false;
  stt.SpeechToText _speech;
  bool _isListening = false;

  TextEditingController textController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  //TODO: Search function
  searching(String value) {
    if (value.length == 0) {
      setState(() {
        isSearch = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      FirebaseFirestore.instance
          .collection('Products')
          .where('search_key', isEqualTo: value.substring(0, 1).toUpperCase())
          .get()
          .then((snapshot) {
        for (var document in snapshot.docs) {
          Product product = new Product(
            id: document['id'],
            productName: document['name'],
            imageList: document['image'],
            category: document['categogy'],
            colorList: document['color'],
            price: document['price'],
            salePrice: document['sale_price'],
            brand: document['brand'],
            madeIn: document['made_in'],
            quantityMain: document['quantity'],
            quantity: '',
            description: document['description'],
            rating: document['rating'],
          );
          queryResultSet.add(product);
          setState(() {
            tempSearchStore = queryResultSet;
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element.productName.toString().startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

//TODO: search voice function
  voiceSearching(String value) {
    if (value.length == 0) {
      setState(() {
        isVoiceSearch = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    if ((value != null && isVoiceSearch == false && _isListening == true) ||
        isVoiceSearch == false && _isListening == true) {
      FirebaseFirestore.instance
          .collection('Products')
          .where('name', isEqualTo: value)
          .get()
          .then((snapshot) {
        for (var document in snapshot.docs) {
          Product product = new Product(
            id: document['id'],
            productName: document['name'],
            imageList: document['image'],
            category: document['categogy'],
            colorList: document['color'],
            price: document['price'],
            salePrice: document['sale_price'],
            brand: document['brand'],
            madeIn: document['made_in'],
            quantityMain: document['quantity'],
            quantity: '',
            description: document['description'],
            rating: document['rating'],
          );
          queryResultSet.add(product);
          setState(() {
            tempSearchStore = queryResultSet;
          });
        }
      });
    }
  }

  //TODO: List searching result
  Widget searchingResult() {
    return Padding(
      padding: EdgeInsets.all(
        ConstScreen.setSizeHeight(30),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        crossAxisSpacing: ConstScreen.setSizeHeight(30),
        mainAxisSpacing: ConstScreen.setSizeHeight(40),
        childAspectRatio: 66 / 110,
        children: tempSearchStore.map((product) {
          return ProductCard(
            productName: product.productName,
            image: product.imageList[0],
            isSoldOut: (product.quantityMain == '0'),
            price: int.parse(product.price),
            salePrice:
                (product.salePrice != '0') ? int.parse(product.salePrice) : 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDetailProductView(
                    product: product,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  //TODO: Category
  Widget category() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        //TODO: Clothing
        ExpansionTile(
          title: Text('Trong nhà',
              style: TextStyle(
                  fontSize: FontSize.setTextSize(32),
                  fontWeight: FontWeight.w400)),
          children: <Widget>[
            CategoryItem(
              title: 'Sen đá',
              onTap: () {
                navigatorTo('Sen');
              },
            ),
            CategoryItem(
              title: 'Xương rồng',
              onTap: () {
                navigatorTo('Xương rồng');
              },
            ),
            CategoryItem(
              title: 'Cỏ',
              onTap: () {
                navigatorTo('Cỏ');
              },
            ),
          ],
        ),
        //TODO: Shoes
        ExpansionTile(
          title: Text(
            'Ngoài trời',
            style: TextStyle(
                fontSize: FontSize.setTextSize(32),
                fontWeight: FontWeight.w400),
          ),
          children: <Widget>[
            CategoryItem(
              title: 'Cao kiểng',
              onTap: () {
                navigatorTo('Cao kiểng');
              },
            ),
            CategoryItem(
              title: 'Hoa',
              onTap: () {
                navigatorTo('Hoa');
              },
            ),
          ],
        ),
        //TODO: Accessories
        ExpansionTile(
          title: Text(
            'Chậu treo',
            style: TextStyle(
                fontSize: FontSize.setTextSize(32),
                fontWeight: FontWeight.w400),
          ),
          children: <Widget>[
            CategoryItem(
              title: 'Lan',
              onTap: () {
                navigatorTo('Lan');
              },
            ),
            CategoryItem(
              title: 'Lan rừng',
              onTap: () {
                navigatorTo('Lan rừng');
              },
            ),
          ],
        ),
      ],
    );
  }

  //TODO: Navigator link
  void navigatorTo(String link) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductListView(
                  search: link,
                )));
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorGreen,
        automaticallyImplyLeading: false,
        title: Text('Tìm kiếm'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: kColorGreen,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: kColorGreen,
          onPressed: _listen,
          child: Icon((_isListening) ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // TODO: Search Bar
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: kColorBlack.withOpacity(0.6),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ConstScreen.setSizeHeight(15),
                        horizontal: ConstScreen.setSizeWidth(20)),
                    child: TextField(
                      controller: textController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kColorBlack.withOpacity(0.6),
                          ),
                        ),
                        hintText: 'Nhập tên sản phẩm để tìm kiếm',
                        hintStyle: TextStyle(
                            fontSize: FontSize.s30,
                            color: kColorBlack,
                            fontWeight: FontWeight.w100),
                        // TODO: Search Button
                        suffixIcon: Icon(
                          Icons.search,
                          color: kColorBlack.withOpacity(0.8),
                          size: ConstScreen.setSizeWidth(45),
                        ),
                      ),
                      style:
                          TextStyle(fontSize: FontSize.s30, color: kColorBlack),
                      maxLines: 1,
                      onChanged: (value) {
                        searching(value);
                        setState(() {
                          isSearch = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              //TODO: Category
              Flexible(
                flex: 9,
                child: (isSearch || isVoiceSearch)
                    ? searchingResult()
                    : category(),
              ),
              // Text(
              //   voiceSearch,
              //   style: TextStyle(
              //     fontSize: 32.0,
              //     color: Colors.black,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() {
          _isListening = true;
          isVoiceSearch = false;
          textController.text = '';

          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        });
        _speech.listen(
          onResult: (val) => setState(() {
            textController.text =
                val.recognizedWords.substring(0, 1).toUpperCase() +
                    val.recognizedWords.substring(1);
            print(textController.text);
          }),
        );
        return voiceSearching(textController.text);
      }
    }

    if (_isListening == true &&
        // _isListening == true &&
        voiceSearching(textController.text) != '') {
      setState(() {
        _isListening = false;
        isVoiceSearch = true;
      });
      _speech.stop();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
