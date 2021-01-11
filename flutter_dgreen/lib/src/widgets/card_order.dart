import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/component/textline_between.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';

class OrderCard extends StatelessWidget {
  OrderCard(
      {this.id = '',
      this.customerName = '',
      this.date = '',
      this.status = '',
      this.total = '',
      this.admin = '',
      this.onViewDetail,
      this.onCancel,
      this.isEnableCancel = true});
  final String id;
  final String customerName;
  final String admin;
  final String date;
  final String status;
  final String total;
  final Function onViewDetail;
  final Function onCancel;
  final bool isEnableCancel;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              TextLineBetween(
                label: 'ID',
                content: id,
                contentStyle: kNormalTextStyle,
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(10),
              ),
              //TODO: Order date

              TextLineBetween(
                label: 'Ngày duyệt',
                content: date,
                contentStyle: kNormalTextStyle,
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(10),
              ),
              //TODO: Admin

              TextLineBetween(
                label: 'Người duyệt',
                content: admin,
                contentStyle: kNormalTextStyle,
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(10),
              ),
              //TODO:Customer's Name
              TextLineBetween(
                label: 'Khách hàng',
                content: customerName,
                contentStyle: kNormalTextStyle,
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(10),
              ),
              // TODO: Status

              TextLineBetween(
                label: 'Trạng thái',
                content: status,
                contentStyle: kNormalTextStyle.copyWith(
                    color: status == 'Completed' ? kColorGreen : kColorRed),
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(10),
              ),
              //TODO: Total price
              TextLineBetween(
                label: 'Giá ',
                content: '$total VNĐ',
                contentStyle: kNormalTextStyle,
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
                          Icons.remove_red_eye,
                          color: kColorBlue,
                          size: ConstScreen.setSizeWidth(30),
                        ),
                        SizedBox(
                          width: ConstScreen.setSizeWidth(7),
                        ),
                        Text(
                          'Xem chi tiết',
                          style: kBoldTextStyle.copyWith(
                              color: kColorBlue, fontSize: FontSize.s28),
                        ),
                      ],
                    ),
                    onTap: () {
                      onViewDetail();
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
                          'Hủy',
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
    );
  }
}
