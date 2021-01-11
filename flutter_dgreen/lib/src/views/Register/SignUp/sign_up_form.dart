import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dgreen/src/component/dropdown_custom.dart';
import 'package:flutter_dgreen/src/helpers/TextStyle.dart';
import 'package:flutter_dgreen/src/helpers/colors_constant.dart';
import 'package:flutter_dgreen/src/helpers/screen.dart';
import 'package:flutter_dgreen/src/helpers/style_constant.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/views/HomePage/Customer/ProfilePage/Detail/detail_controller.dart';
import 'package:flutter_dgreen/src/widgets/button_normal.dart';
import 'package:flutter_dgreen/src/widgets/button_raised.dart';
import 'package:flutter_dgreen/src/widgets/input_normal.dart';
import 'package:flutter_dgreen/src/widgets/input_text.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'sign_up_controller.dart';

class SignUpView extends StatefulWidget {
  SignUpView({this.typeAccount});
  final String typeAccount;
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<String> gender = ['Nam', 'Nữ'];
  String _genderData;
  bool _isRegisterLoading = true;
  SignUpController signUpController = new SignUpController();
  DetailUserInfoController _controller = new DetailUserInfoController();

  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPwd = '';
  bool obscureText = true;
  bool isLoading = false;
  bool focusBorder = false;
  DateTime birthDay;
  bool _isBirthdayConfirm = false;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // TODO: Full Name
        StreamBuilder(
          stream: signUpController.fullNameStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.person_outline),
            title: 'Họ tên',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _fullName = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: phone number
        StreamBuilder(
          stream: signUpController.phoneStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.phone_android),
            title: 'Số điện thoại',
            inputType: TextInputType.number,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _phone = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: email
        StreamBuilder(
          stream: signUpController.emailStream,
          builder: (context, snapshot) => InputText(
            icon: Icon(Icons.mail),
            title: 'Email',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _email = value;
            },
          ),
        ),

        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: Password
        StreamBuilder(
          stream: signUpController.passwordStream,
          builder: (context, snapshot) => InputText(
            title: 'Mật khẩu',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _password = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: Confirm Password
        StreamBuilder(
          stream: signUpController.confirmPwdSteam,
          builder: (context, snapshot) => InputText(
            title: 'Xác nhận mật khẩu',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _confirmPwd = value;
            },
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        //TODO: Ngày Sinh
        Stack(
          children: <Widget>[
            IgnorePointer(
              child: StreamBuilder<Object>(
                  stream: _controller.birthdayStream,
                  builder: (context, snapshot) {
                    return InputNormal(
                      labelText: 'Ngày sinh',
                      textError: snapshot.hasError ? snapshot.error : '',
                      children: TextField(
                        controller: TextEditingController(text: _birthday),
                        style: TextStyle(
                          fontSize: setFontSize(size: 32.0),
                          color: kColorBody,
                        ),
                        decoration: kInputTextDecoration.copyWith(
                          hintText: 'Ngày/Tháng/Năm',
                          hintStyle: TextStyle(
                            height: 1.7,
                            fontSize: 14,
                            backgroundColor: Colors.white,
                            color: kColorBody,
                          ),
                          suffixIcon: GestureDetector(
                            child: Icon(
                              Icons.calendar_today,
                              size: setFontSize(size: 32.0),
                              color: kColorGrey,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1950, 12, 31),
                    maxTime: DateTime(DateTime.now().year, 12, 31),
                    theme: DatePickerTheme(
                      headerColor: kColorGreen,
                      doneStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onChanged: (date) {
                      print('change $date');
                      birthDay = date;
                    },
                    onConfirm: (date) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      birthDay = date;
                      _birthday = (birthDay.day.toString() +
                          '/' +
                          birthDay.month.toString() +
                          '/' +
                          birthDay.year.toString());
                      setState(
                        () {
                          setState(() {
                            _isBirthdayConfirm = true;
                          });
                        },
                      );
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.vi,
                  );
                },
                child: Container(
                  color: Colors.black.withOpacity(0),
                  height: 60,
                  width: 300,
                ),
              ),
            )
          ],
        ),

        StreamBuilder<Object>(
            stream: _controller.genderStream,
            builder: (context, snapshot) {
              return DropdownCustom(
                textError: snapshot.hasError ? snapshot.error : '',
                iconSize: 32,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: kColorGrey,
                ),
                listItem: gender,
                itemSelected: _genderData,
                hintText: 'Chọn giới tính',
                labelText: 'GIỚI TÍNH',
                onChanged: (value) {
                  setState(() {
                    _genderData = value;
                  });
                },
              );
            }),

        //TODO: Image product
        Text(
          'Hình ảnh:',
          style: kBoldTextStyle.copyWith(fontSize: FontSize.setTextSize(34)),
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
            stream: signUpController.btnLoadingStream,
            builder: (context, snapshot) {
              return ButtonNormal(
                isLoading: isLoading,
                // hasSuffixIcon: true,
                isBtnColor: true,
                text: 'ĐĂNG KÍ',
                onPress: () async {
                  bool result = await signUpController.onSubmitRegister(
                    fullName: _fullName,
                    phone: _phone,
                    email: _email,
                    password: _password,
                    confirmPwd: _confirmPwd,
                    typeAccount: widget.typeAccount,
                    avatar: _avatar,
                    birthday: _birthday,
                    gender: _genderData,
                  );

                  if (result == true) {
                    if (widget.typeAccount == 'customer') {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    } else {
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
                                'Thêm người dùng thành công',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: FontSize.s28),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
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
                              'Đăng kí thất bại.',
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
      ],
    );
  }
}
