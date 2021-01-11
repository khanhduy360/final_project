import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';
import 'package:flutter_dgreen/src/helpers/validator.dart';
import 'package:flutter_dgreen/src/model/user.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SignUpController {
  StreamController _isFullNameController = new StreamController();
  StreamController _isPhoneController = new StreamController();
  StreamController _isEmailController = new StreamController();
  StreamController _isPasswordController = new StreamController();
  StreamController _isConfirmPwdController = new StreamController();
  StreamController _isBtnLoadingController = new StreamController();
  StreamController _genderController = new StreamController.broadcast();
  StreamController _birthdayController = new StreamController.broadcast();
  StreamController _avatarController = new StreamController.broadcast();

  Stream get fullNameStream => _isFullNameController.stream;
  Stream get phoneStream => _isPhoneController.stream;
  Stream get emailStream => _isEmailController.stream;
  Stream get passwordStream => _isPasswordController.stream;
  Stream get confirmPwdSteam => _isConfirmPwdController.stream;
  Stream get btnLoadingStream => _isBtnLoadingController.stream;
  Stream get genderStream => _genderController.stream;
  Stream get birthdayStream => _birthdayController.stream;
  Stream get avatarStream => _avatarController.stream;

  Validators validators = new Validators();

  onSubmitRegister({
    @required String fullName,
    @required String phone,
    @required String email,
    @required String password,
    @required String confirmPwd,
    @required String typeAccount,
    @required String birthday,
    @required String gender,
    @required List<Asset> avatar,
  }) async {
    int countError = 0;
    _isFullNameController.sink.add('');
    _isPhoneController.sink.add('');
    _isEmailController.sink.add('');
    _isPasswordController.sink.add('');
    _isConfirmPwdController.sink.add('');
    _birthdayController.sink.add('');
    _genderController.sink.add('');
    _avatarController.sink.add('');

    if (fullName == '' || fullName == null) {
      _isFullNameController.sink.addError('Invalid full name.');
      countError++;
    }

    if (phone == '' || phone == null || !validators.isPhoneNumber(phone)) {
      _isPhoneController.sink.addError('Invalid phone.');
      countError++;
    }

    if (!validators.isValidEmail(email)) {
      _isEmailController.sink.addError('Invalid email address.');
      countError++;
    }

    if (!validators.isPassword(password)) {
      _isPasswordController.sink.addError('Invalid password.');
      countError++;
    }

    if (!validators.isPassword(confirmPwd)) {
      _isConfirmPwdController.sink.addError('Invalid confirm password.');
      countError++;
    }
    if (password != confirmPwd) {
      _isConfirmPwdController.sink
          .addError('Confirm passoword does not match.');
      countError++;
    }
    if (birthday == '' || birthday == null) {
      _birthdayController.sink.addError('Invalid birthday.');
      countError++;
    }
    if (avatar.length == 0) {
      _avatarController.sink.addError('Chọn hình ảnh.');
      countError++;
    }
    if (gender == null) {
      _genderController.sink.addError('Gender does not choose.');
      countError++;
    }

    //TODO: Accept Sign Up
    if (countError == 0) {
      try {
        _isBtnLoadingController.sink.add(false);
        //TODO: Create account
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        List<String> linkAvatar = await saveImage(avatar);
        print(linkAvatar.length);
        User user = (await firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;

        //TODO: Add data to database
        String createAt = user.metadata.creationTime.toString();
        //TODO: encode password
        String pwdSha512 = Util.encodePassword(password);
        FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'id': user.uid,
          'username': email,
          'password': pwdSha512,
          'fullname': fullName,
          'gender': gender,
          'birthday': birthday,
          'avatar': linkAvatar,
          'phone': phone,
          'address': '',
          'create_at': createAt,
          'id_scripe': '',
          'type': typeAccount,
        });
        UserApp userInfo = new UserApp(
            fullName,
            email,
            password,
            linkAvatar.toString(),
            gender,
            birthday,
            '',
            createAt,
            '',
            'customer',
            '');
        await StorageUtil.setUid(user.uid);
        await StorageUtil.setFullName(fullName);
        await StorageUtil.setIsLogging(true);
        await StorageUtil.setUserInfo(userInfo);
        await StorageUtil.setAccountType('customer');
        await StorageUtil.setPassword(pwdSha512);

        _isBtnLoadingController.sink.add(true);
        return true;
      } catch (e) {
        _isEmailController.sink.addError('The email address is already in use');
        _isBtnLoadingController.sink.add(true);
      }
    }
  }

//TODO Save Image to Firebase Storage
  Future saveImage(List<Asset> asset) async {
    UploadTask uploadTask;
    List<String> linkImage = [];
    for (var value in asset) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
//      int width = 500;
//      int height = ((width * value.originalHeight) / width).round();
      ByteData byteData = await value.getByteData(quality: 70);
      var imageData = byteData.buffer.asUint8List();
      uploadTask = ref.putData(imageData);
      String imageUrl;
      await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL()
          .then((onValue) {
        imageUrl = onValue;
      });
      linkImage.add(imageUrl);
    }
    return linkImage;
  }

  void dispose() {
    _isFullNameController.close();
    _isEmailController.close();
    _isConfirmPwdController.close();
    _isPasswordController.close();
    _isPhoneController.close();
    _isBtnLoadingController.close();
    _birthdayController.close();
    _avatarController.close();
    _genderController.close();
  }
}
