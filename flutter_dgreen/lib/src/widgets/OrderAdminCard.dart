import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class OrderAdminCard extends StatelessWidget {
  OrderAdminCard(
      {this.id = '',
      this.customerName = '',
      this.date = '',
      this.status = '',
      this.total = '',
      this.onAccept,
      this.onCancel,
      this.onViewDetail,
      this.isEnableCancel = true});
  final String id;
  final String customerName;
  final String date;
  final String status;
  final String total;
  final Function onAccept;
  final Function onCancel;
  final Function onViewDetail;
  final bool isEnableCancel;

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Card(
      child: GestureDetector(
        onTap: () {
          onViewDetail();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kColorLightGrey),
            color: kColorWhite,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ConstScreen.setSizeWidth(25),
                vertical: ConstScreen.setSizeHeight(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // TODO: Order id
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: FontSize.s30,
                    ),
                    children: [
                      TextSpan(
                        text: 'Order Id: ',
                      ),
                      TextSpan(
                        text: id,
                        style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.s30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstScreen.setSizeHeight(10),
                ),
                //TODO: Order date
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: FontSize.s30,
                    ),
                    children: [
                      TextSpan(
                        text: 'Order Date: ',
                      ),
                      TextSpan(
                        text: date,
                        style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.s30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstScreen.setSizeHeight(10),
                ),
                //TODO:Customer's Name
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: FontSize.s30,
                    ),
                    children: [
                      TextSpan(
                        text: 'Customer: ',
                      ),
                      TextSpan(
                        text: customerName,
                        style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.s30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstScreen.setSizeHeight(10),
                ),
                // TODO: Status
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: FontSize.s30,
                    ),
                    children: [
                      TextSpan(
                        text: 'Status: ',
                      ),
                      TextSpan(
                        text: status,
                        style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.s30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ConstScreen.setSizeHeight(10),
                ),
                //TODO: Total price
                AutoSizeText.rich(
                  TextSpan(
                    style: kBoldTextStyle.copyWith(
                      fontSize: FontSize.s30,
                    ),
                    children: [
                      TextSpan(
                        text: 'Total: ',
                      ),
                      TextSpan(
                        text: '$total VND',
                        style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.s30,
                        ),
                      ),
                    ],
                  ),
                ),
                //TODO: ViewDetail and CancelOrder
                SizedBox(
                  height: ConstScreen.setSizeHeight(15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // TODO: View detail
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: kColorGreen,
                            size: ConstScreen.setSizeWidth(30),
                          ),
                          SizedBox(
                            width: ConstScreen.setSizeWidth(7),
                          ),
                          Text(
                            'ACCEPT',
                            style: kBoldTextStyle.copyWith(
                                color: kColorGreen, fontSize: FontSize.s28),
                          ),
                        ],
                      ),
                      onTap: () {
                        onAccept();
                      },
                    ),
                    //TODO: Cancel Order
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            color: isEnableCancel
                                ? kColorRed
                                : kColorBlack.withOpacity(0.7),
                            size: ConstScreen.setSizeWidth(30),
                          ),
                          SizedBox(
                            width: ConstScreen.setSizeWidth(7),
                          ),
                          Text(
                            'CANCEL',
                            style: kBoldTextStyle.copyWith(
                                color: isEnableCancel
                                    ? kColorRed
                                    : kColorBlack.withOpacity(0.7),
                                fontSize: FontSize.s28),
                          ),
                        ],
                      ),
                      onTap: () {
                        if (isEnableCancel) {
                          onCancel();
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
