import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_dgreen/link.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bank_acount_adding_view.dart';
import 'bank_card_controller.dart';

class BankAccountView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();
  @override
  _BankAccountViewState createState() => _BankAccountViewState();
}

class _BankAccountViewState extends State<BankAccountView> {
  BankCardController _controller = new BankCardController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StorageUtil.getUid().then((uid) {
      _controller.uidSink.add(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      backgroundColor: kColorWhite,
      key: widget._globalKey,
      appBar: AppBar(
        title: Text(
          'Thẻ ngân hàng',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.edit),
            color: kColorBlack,
            iconSize: ConstScreen.setSizeWidth(35),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BankAccountAddingView()));
            },
          )
        ],
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _controller.uidStream,
          builder: (context, mainSnapshot) {
            if (mainSnapshot.hasData) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Cards')
                    .where('uid', isEqualTo: mainSnapshot.data)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && mainSnapshot.hasData) {
                    if (snapshot.data.docs.length != 0) {
                      return Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ConstScreen.setSizeWidth(80)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  gradient: LinearGradient(
                                    colors: [Colors.blue, kColorCyan],
                                    stops: [0.0, 0.7],
                                  )),
                            ),
                          ),
                          //TODO: list card
                          ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return Center(
                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'Delete',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('Cards')
                                            .doc(document.id)
                                            .delete();
                                      },
                                    ),
                                  ],
                                  child: CreditCardWidget(
                                    height: ConstScreen.setSizeHeight(380),
                                    width: ConstScreen.setSizeWidth(600),
                                    textStyle: TextStyle(
                                        fontSize: FontSize.setTextSize(34),
                                        color: kColorWhite,
                                        fontWeight: FontWeight.bold),
                                    cardNumber: document['cardNumber'],
                                    expiryDate:
                                        '${document['expiryMonth'].toString()} / ${document['expiryYear'].toString()}',
                                    cardHolderName: document['cardHolderName'],
                                    cvvCode: document['cvvCode'],
                                    showBackView: false,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        width: ConstScreen.setSizeWidth(700),
                        height: ConstScreen.setSizeHeight(1000),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: ConstScreen.setSizeWidth(350),
                              left: ConstScreen.setSizeHeight(200),
                              child: Container(
                                width: ConstScreen.setSizeWidth(374),
                                height: ConstScreen.setSizeHeight(220),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        KImageAddress + 'noCreditCard.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: ConstScreen.setSizeHeight(650),
                              left: ConstScreen.setSizeWidth(190),
                              child: Text(
                                ' No Credit Card Found',
                                style: kBoldTextStyle.copyWith(
                                    color: kColorBlack.withOpacity(0.8),
                                    fontSize: FontSize.s36,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
