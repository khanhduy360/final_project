import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/src/helpers/TextStyle.dart';
import 'package:flutter_final_project/src/helpers/colors_constant.dart';
import 'package:flutter_final_project/src/helpers/screen.dart';
import 'package:flutter_final_project/src/widgets/button_raised.dart';
import 'package:flutter_final_project/src/widgets/input_text.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'detail_controller.dart';

class EditDetailView extends StatefulWidget {
  @override
  _EditDetailViewState createState() => _EditDetailViewState();
}

class _EditDetailViewState extends State<EditDetailView> {
  DetailUserInfoController _controller = new DetailUserInfoController();
  DateTime birthDay;
  bool _isBirthdayConfirm = false;
  bool _isEditPage = false;
  List<String> gender = ['Male', 'Female'];
  //TODO: data
  String _fullName;
  String _address;
  String _genderData;
  String _phone;
  String _birthday;

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Detail',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Container(
        color: kColorWhite,
        child: Padding(
          padding: EdgeInsets.only(
              left: ConstScreen.setSizeWidth(20),
              right: ConstScreen.setSizeWidth(20),
              top: ConstScreen.setSizeWidth(50)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //TODO: First & Last Name
              StreamBuilder(
                  stream: _controller.fullNameStream,
                  builder: (context, snapshot) {
                    return InputText(
                      title: 'Full Name',
                      errorText: snapshot.hasError ? snapshot.error : '',
                      onValueChange: (value) {
                        _fullName = value;
                      },
                    );
                  }),

              SizedBox(
                height: ConstScreen.setSizeHeight(20),
              ),
              //TODO: Address
              StreamBuilder(
                  stream: _controller.addressStream,
                  builder: (context, snapshot) {
                    return InputText(
                      title: 'Address',
                      errorText: snapshot.hasError ? snapshot.error : '',
                      onValueChange: (value) {
                        _address = value;
                      },
                    );
                  }),

              SizedBox(
                height: ConstScreen.setSizeHeight(20),
              ),
              //TODO: Mobile Phone and Gender picker
              Row(
                children: <Widget>[
                  //TODO: Mobile Phone
                  StreamBuilder(
                      stream: _controller.phoneStream,
                      builder: (context, snapshot) {
                        return Expanded(
                          flex: 2,
                          child: InputText(
                            title: 'Mobile',
                            errorText: snapshot.hasError ? snapshot.error : '',
                            inputType: TextInputType.number,
                            onValueChange: (value) {
                              _phone = value;
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    width: ConstScreen.setSizeWidth(15),
                  ),
                  //TODO: Gender picker
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: ConstScreen.setSizeHeight(6),
                          bottom: ConstScreen.setSizeHeight(6),
                          left: ConstScreen.setSizeHeight(6),
                        ),
                        child: Center(
                          child: StreamBuilder(
                              stream: _controller.genderStream,
                              builder: (context, snapshot) {
                                return DropdownButton(
                                  isExpanded: true,
                                  value: _genderData,
                                  hint: (snapshot.hasError)
                                      ? AutoSizeText(
                                          snapshot.error,
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: FontSize.s30,
                                              color: kColorRed),
                                          minFontSize: 10,
                                          maxLines: 1,
                                        )
                                      : AutoSizeText(
                                          'Choose gender',
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: FontSize.s30,
                                              color: kColorBlack),
                                          minFontSize: 10,
                                          maxLines: 1,
                                        ),
                                  onChanged: (value) {
                                    setState(() {
                                      _genderData = value;
                                    });
                                  },
                                  items: gender.map((String value) {
                                    return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: kBoldTextStyle.copyWith(
                                              fontSize: FontSize.s30),
                                        ));
                                  }).toList(),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(20),
              ),
              //TODO: Date Picker
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1950, 12, 31),
                      maxTime: DateTime(DateTime.now().year, 12, 31),
                      onChanged: (date) {
                    print('change $date');
                    birthDay = date;
                  }, onConfirm: (date) {
                    birthDay = date;
                    _birthday = (birthDay.day.toString() +
                        '/' +
                        birthDay.month.toString() +
                        '/' +
                        birthDay.year.toString());
                    setState(() {
                      _isBirthdayConfirm = true;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.vi);
                },
                child: Container(
                  height: ConstScreen.setSizeHeight(100),
                  decoration: BoxDecoration(
                      border: Border.all(color: kColorBlack.withOpacity(0.7))),
                  child: Center(
                    child: Text(
                      _isBirthdayConfirm
                          ? ('Birthday: ' +
                              birthDay.day.toString() +
                              '/' +
                              birthDay.month.toString() +
                              '/' +
                              birthDay.year.toString())
                          : 'Birthday Picker',
                      style: TextStyle(
                          color: kColorBlack,
                          fontSize: FontSize.s30,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(20),
              ),
              StreamBuilder(
                  stream: _controller.btnLoading,
                  builder: (context, snapshot) {
                    return CusRaisedButton(
                      height: 90,
                      title: 'Save',
                      isDisablePress: snapshot.hasData ? snapshot.data : true,
                      backgroundColor: kColorBlack,
                      onPress: () async {
                        bool result = await _controller.onSave(
                            fullName: _fullName,
                            address: _address,
                            phone: _phone,
                            gender: _genderData,
                            birthday: _birthday);
                        if (result) {
                          setState(() {
                            _isEditPage = !_isEditPage;
                          });
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
                                    'Update profile failed.',
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
