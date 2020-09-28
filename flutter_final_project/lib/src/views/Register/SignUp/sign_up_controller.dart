import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_final_project/src/helpers/shared_preferrence.dart';
import 'package:flutter_final_project/src/helpers/utils.dart';
import 'package:flutter_final_project/src/helpers/validator.dart';
import 'package:flutter_final_project/src/model/user.dart';

class SignUpController {
  StreamController _isFullNameController = new StreamController();
  StreamController _isPhoneController = new StreamController();
  StreamController _isEmailController = new StreamController();
  StreamController _isPasswordController = new StreamController();
  StreamController _isConfirmPwdController = new StreamController();
  StreamController _isBtnLoadingController = new StreamController();

  Stream get fullNameStream => _isFullNameController.stream;
  Stream get phoneStream => _isPhoneController.stream;
  Stream get emailStream => _isEmailController.stream;
  Stream get passwordStream => _isPasswordController.stream;
  Stream get confirmPwdSteam => _isConfirmPwdController.stream;
  Stream get btnLoadingStream => _isBtnLoadingController.stream;

  Validators validators = new Validators();

  onSubmitRegister({
    @required String fullName,
    @required String phone,
    @required String email,
    @required String password,
    @required String confirmPwd,
    @required String typeAccount,
  }) async {
    int countError = 0;
    _isFullNameController.sink.add('');
    _isPhoneController.sink.add('');
    _isEmailController.sink.add('');
    _isPasswordController.sink.add('');
    _isConfirmPwdController.sink.add('');

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

    //TODO: Accept Sign Up
    if (countError == 0) {
      try {
        _isBtnLoadingController.sink.add(false);
        //TODO: Create account
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: password))
            .user;

        //TODO: Add data to database
        String createAt = user.metadata.creationTime.toString();
        //TODO: encode password
        String pwdSha512 = Util.encodePassword(password);
        Firestore.instance.collection('Users').document(user.uid).setData({
          'id': user.uid,
          'username': email,
          'password': pwdSha512,
          'fullname': fullName,
          'gender': '',
          'birthday': '',
          'phone': phone,
          'address': '',
          'create_at': createAt,
          'id_scripe': '',
          'type': typeAccount,
        });
        User userInfo = new User(fullName, email, password, '', '', '', '',
            createAt, '', 'customer');
        StorageUtil.setUid(user.uid);
        StorageUtil.setFullName(fullName);
        await StorageUtil.setIsLogging(true);
        StorageUtil.setUserInfo(userInfo);
        StorageUtil.setAccountType('customer');
        StorageUtil.setPassword(pwdSha512);
        _isBtnLoadingController.sink.add(true);
        return true;
      } catch (e) {
        _isEmailController.sink.addError('The email address is already in use');
        _isBtnLoadingController.sink.add(true);
      }
    }
  }

  void dispose() {
    _isFullNameController.close();
    _isEmailController.close();
    _isConfirmPwdController.close();
    _isPasswordController.close();
    _isPhoneController.close();
    _isBtnLoadingController.close();
  }
}
