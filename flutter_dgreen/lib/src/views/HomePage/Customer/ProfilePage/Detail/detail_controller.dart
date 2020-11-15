import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class DetailUserInfoController {
  StreamController _fullNameController = new StreamController.broadcast();
  StreamController _addressController = new StreamController.broadcast();
  StreamController _phoneController = new StreamController.broadcast();
  StreamController _genderController = new StreamController.broadcast();
  StreamController _birthdayController = new StreamController.broadcast();
  StreamController _btnLoadingController = new StreamController.broadcast();
  StreamController _uidController = new StreamController.broadcast();
  StreamController _avatarController = new StreamController.broadcast();

  Sink get uidSink => _uidController.sink;
  Stream get uidStream => _uidController.stream;

  Stream get fullNameStream => _fullNameController.stream;
  Stream get addressStream => _addressController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get genderStream => _genderController.stream;
  Stream get birthdayStream => _birthdayController.stream;
  Stream get btnLoading => _btnLoadingController.stream;
  Stream get avatarStream => _avatarController.stream;

  onSave({
    String fullName,
    String address,
    String phone,
    String gender,
    String birthday,
    List<Asset> avatar,
  }) async {
    _fullNameController.sink.add('');
    _addressController.sink.add('');
    _phoneController.sink.add('');
    _genderController.add('');
    _avatarController.add('');

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
    if (avatar.length == 0) {
      _avatarController.sink.addError('Chọn hình ảnh.');
      countError++;
    }
    print(countError);
    if (countError == 0) {
      final userInfo = await StorageUtil.getUserInfo();
      final uid = await StorageUtil.getUid();
      List<String> linkAvatar = await saveImage(avatar);
      print(linkAvatar.length);
      await FirebaseFirestore.instance.collection('Users').doc(uid).update({
        'fullname': fullName,
        'address': address,
        'phone': phone,
        'gender': gender,
        'birthday':
            (birthday == '' || birthday == null) ? userInfo.birthday : birthday,
        'avatar': linkAvatar,
      });
      return true;
    }
    return false;
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
    _fullNameController.close();
    _addressController.close();
    _phoneController.close();
    _genderController.close();
    _birthdayController.close();
    _btnLoadingController.close();
    _uidController.close();
    _avatarController.close();
  }
}
