import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dgreen/src/helpers/shared_preferrence.dart';
import 'package:flutter_dgreen/src/helpers/utils.dart';

class ChangePwdController {
  StreamController _currentPwdSController = new StreamController();
  StreamController _newPwdController = new StreamController();
  StreamController _confirmPwdController = new StreamController();
  StreamController _btnLoadingController = new StreamController();

  Stream get currentPwdStream => _currentPwdSController.stream;
  Stream get newPwdStream => _newPwdController.stream;
  Stream get confirmPwdStream => _confirmPwdController.stream;
  Stream get btnLoadingStream => _btnLoadingController.stream;

  onChangePwd({
    String currentPwd,
    String newPwd,
    String confirmPwd,
  }) async {
    _currentPwdSController.sink.add('');
    _newPwdController.sink.add('');
    _confirmPwdController.sink.add('');
    int countError = 0;
    if (currentPwd == '' || currentPwd == null || currentPwd.length < 6) {
      _currentPwdSController.sink
          .addError('Mật khẩu hiện tại không chính xác.');
      countError++;
    }

    if (newPwd == '' || newPwd == null || currentPwd.length < 6) {
      _newPwdController.sink.addError('Mật khẩu mới quá ngắn.');
      countError++;
    }

    if (confirmPwd == '' || confirmPwd == null || currentPwd.length < 6) {
      _confirmPwdController.sink
          .addError('Xác nhận mật khẩu không trùng khớp.');
      countError++;
    }

    if (newPwd != confirmPwd) {
      _confirmPwdController.sink.addError('Confirm passoword does not match.');
      countError++;
    }

    String originalPwd;
    originalPwd = await StorageUtil.getPassword();
    if (originalPwd != Util.encodePassword(currentPwd)) {
      _currentPwdSController.addError('Mật khẩu không đúng.');
      countError++;
    }

    //TODO: Change password
    if (countError == 0) {
      _btnLoadingController.sink.add(false);
      // TODO: Sign up Auth and change password
      String uid = await StorageUtil.getUid();
      var userInfo = await StorageUtil.getUserInfo();
      String username = userInfo.username;
      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: username, password: currentPwd))
          .user;
      user.updatePassword(newPwd);
      // TODO: update new password to cloud
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'password': Util.encodePassword(newPwd)});
      StorageUtil.setPassword(Util.encodePassword(newPwd));
      _btnLoadingController.sink.add(true);
      return true;
    }
    return false;
  }

  void dispose() {
    _currentPwdSController.close();
    _newPwdController.close();
    _confirmPwdController.close();
    _btnLoadingController.close();
  }
}
