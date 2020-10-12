import 'dart:convert';

import 'package:flutter_dgreen/src/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  //TODO: SET UID
  static Future<void> setUid(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('uid', value);
  }

  //TODO: GET UID
  static Future<String> getUid() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('uid');
  }

  //TODO: SET Full name
  static Future<void> setFullName(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('fullname', value);
  }

  //TODO: GET Full name
  static Future<String> geFullName() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('fullname');
  }

  //TODO: SET password
  static Future<void> setPassword(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('password', value);
  }

  //TODO: GET password
  static Future<String> getPassword() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('password');
  }

  //TODO: SET Is Logging
  static Future<void> setIsLogging(bool value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('isLogging', value);
  }

  //TODO: GET Is Logging
  static Future<bool> getIsLogging() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool('isLogging');
  }

  //TODO: SET Account Type
  static Future<void> setAccountType(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.setString('accountType', value);
  }

  //TODO: GET Account Type
  static Future<String> getAccountType() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('accountType');
  }

  //TODO: Set User info
  static Future<void> setUserInfo(UserApp user) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('UserInfo', jsonEncode(user.toJson()));
  }

  //TODO: get User info
  static Future<UserApp> getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserApp user =
        new UserApp.fromJson(jsonDecode(preferences.getString('UserInfo')));
    return user;
  }

  //TODO: Clear Data
  static Future<void> clear() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }
}
