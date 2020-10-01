import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bank_card_controller.dart';

class BankAccountAddingView extends StatefulWidget {
  final _globalKey = new GlobalKey<ScaffoldState>();
  @override
  _BankAccountAddingViewState createState() => _BankAccountAddingViewState();
}

class _BankAccountAddingViewState extends State<BankAccountAddingView> {
  BankCardController _controller = new BankCardController();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isAddPage = false;

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
            'Add Bank Card',
            style: kBoldTextStyle.copyWith(
              fontSize: FontSize.setTextSize(32),
            ),
          ),
          centerTitle: true,
          backgroundColor: kColorWhite,
          iconTheme: IconThemeData.fallback(),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: ConstScreen.setSizeHeight(20),
                horizontal: ConstScreen.setSizeHeight(30)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // TODO Card view
                    Center(
                      child: CreditCardWidget(
                        height: ConstScreen.setSizeHeight(380),
                        width: ConstScreen.setSizeWidth(600),
                        textStyle: TextStyle(
                            fontSize: FontSize.setTextSize(34),
                            color: kColorWhite,
                            fontWeight: FontWeight.bold),
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        showBackView: false,
                      ),
                    ),
                    //TODO: Card Data
                    CreditCardForm(
                      themeColor: Colors.blue,
                      cardHolderName: cardHolderName,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cvvCode: cvvCode,
                      onCreditCardModelChange: (CreditCardModel data) {
                        setState(() {
                          cardNumber = data.cardNumber;
                          expiryDate = data.expiryDate;
                          cardHolderName = data.cardHolderName;
                          cvvCode = data.cvvCode;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: // TODO: Add card Button
            Container(
          child: StreamBuilder(
              stream: _controller.btnLoadStream,
              builder: (context, snapshot) {
                return CusRaisedButton(
                  title: 'ADD',
                  height: 100,
                  backgroundColor: kColorBlack,
                  isDisablePress: snapshot.hasData ? snapshot.data : true,
                  onPress: () async {
                    print(cardHolderName);
                    print(expiryDate.length);
                    print(cvvCode);
                    print(cardHolderName);
                    String result = await _controller.onAdd(
                        cardHolderName: cardHolderName,
                        cardNumber: cardNumber.replaceAll(
                            new RegExp(r"\s+\b|\b\s"), ""),
                        cvvCode: cvvCode,
                        expiryDate: expiryDate);
                    if (result == 'true') {
                      setState(() {});
                      Scaffold.of(context).showSnackBar(SnackBar(
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
                                'Adding Card Success.',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: FontSize.s28),
                              ),
                            )
                          ],
                        ),
                      ));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
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
                                '$result .',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: FontSize.s28),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
                  },
                );
              }),
        ));
  }
}
