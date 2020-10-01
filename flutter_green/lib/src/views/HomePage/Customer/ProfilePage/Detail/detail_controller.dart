import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_green/src/helpers/shared_preferrence.dart';

class DetailUserInfoController {
  StreamController _fullNameController = new StreamController.broadcast();
  StreamController _addressController = new StreamController.broadcast();
  StreamController _phoneController = new StreamController.broadcast();
  StreamController _genderController = new StreamController.broadcast();
  StreamController _birthdayController = new StreamController.broadcast();
  StreamController _btnLoadingController = new StreamController.broadcast();
  StreamController _uidController = new StreamController.broadcast();

  Sink get uidSink => _uidController.sink;
  Stream get uidStream => _uidController.stream;

  Stream get fullNameStream => _fullNameController.stream;
  Stream get addressStream => _addressController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get genderStream => _genderController.stream;
  Stream get birthdayStream => _birthdayController.stream;
  Stream get btnLoading => _btnLoadingController.stream;

  onSave({
    String fullName,
    String address,
    String phone,
    String gender,
    String birthday,
  }) async {
    _fullNameController.sink.add('');
    _addressController.sink.add('');
    _phoneController.sink.add('');
    _genderController.add('');

    int countError = 0;

    if (fullName == '' || fullName == null) {
      _fullNameController.sink.addError('Full name is empty.');
      countError++;
    }

    if (address == '' || address == null) {
      _addressController.sink.addError('Address is empty.');
      countError++;
    }

    if (phone == '' || phone == null) {
      _phoneController.sink.addError('Phone is empty.');
      countError++;
    }

    if (gender == null) {
      _genderController.sink.addError('Gender does not choose.');
      countError++;
    }
    print(countError);
    if (countError == 0) {
      final userInfo = await StorageUtil.getUserInfo();
      final uid = await StorageUtil.getUid();
      await Firestore.instance.collection('Users').document(uid).updateData({
        'fullname': fullName,
        'address': address,
        'phone': phone,
        'gender': gender,
        'birthday':
            (birthday == '' || birthday == null) ? userInfo.birthday : birthday
      });
      return true;
    }
    return false;
  }

  void dispose() {
    _fullNameController.close();
    _addressController.close();
    _phoneController.close();
    _genderController.close();
    _birthdayController.close();
    _btnLoadingController.close();
    _uidController.close();
  }
}
