import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  List<String> gender = ['Nam', 'Nữ'];
  //TODO: data
  String _fullName;
  String _address;
  String _genderData;
  String _phone;
  String _birthday;
  List<Asset> _avatar = List<Asset>();
//TODO: Image product holder
  Widget imageGridView() {
    return GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      children: List.generate(_avatar.length, (index) {
        Asset asset = _avatar[index];
        return Padding(
          padding: EdgeInsets.all(20),
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
        selectedAssets: _avatar,
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
      _avatar = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chỉnh sửa thông tin',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: SingleChildScrollView(
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
                      title: 'Họ tên',
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
                      title: 'Địa chỉ',
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
                            title: 'Số điện thoại',
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
                                          'Chọn giới tính',
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
                          ? ('Ngày sinh: ' +
                              birthDay.day.toString() +
                              '/' +
                              birthDay.month.toString() +
                              '/' +
                              birthDay.year.toString())
                          : 'Chọn ngày sinh',
                      style: TextStyle(
                          color: kColorBlack,
                          fontSize: FontSize.s30,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              //TODO: Image product
              Text(
                'Hình ảnh:',
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
                stream: _controller.avatarStream,
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
              StreamBuilder(
                  stream: _controller.btnLoading,
                  builder: (context, snapshot) {
                    return CusRaisedButton(
                      height: 90,
                      title: 'Lưu lại',
                      isDisablePress: snapshot.hasData ? snapshot.data : true,
                      backgroundColor: kColorBlue,
                      onPress: () async {
                        bool result = await _controller.onSave(
                            fullName: _fullName,
                            address: _address,
                            phone: _phone,
                            gender: _genderData,
                            birthday: _birthday,
                            avatar: _avatar);
                        if (result) {
                          setState(() {
                            _isEditPage = !_isEditPage;
                          });
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.pop(context);
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
                                    'Cập nhật thông tin thất bại.',
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
