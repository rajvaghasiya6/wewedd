import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';
import 'string_constants.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  Future<bool> logout(BuildContext context) async {
    _sharedPrefs!.clear();
    context.read<ThemeProvider>().setDark();
    if (sharedPrefs.userId.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  //getter
  String get mobileNo =>
      _sharedPrefs!.getString(StringConstants.mobileNo) ?? "";

  String get guestId => _sharedPrefs!.getString(StringConstants.guestId) ?? "";

  String get userId => _sharedPrefs!.getString(StringConstants.userId) ?? "";

  String get userName =>
      _sharedPrefs!.getString(StringConstants.userName) ?? "";

  String get guestName =>
      _sharedPrefs!.getString(StringConstants.guestName) ?? "";

  String get guestProfileImage =>
      _sharedPrefs!.getString(StringConstants.guestProfileImage) ?? "";

  List<String> get guestIdProof =>
      _sharedPrefs!.getStringList(StringConstants.guestIdProof) ?? [];

  String get primaryTheme =>
      _sharedPrefs!.getString(StringConstants.primaryTheme) ?? "";

  String get marriageId =>
      _sharedPrefs!.getString(StringConstants.marriageId) ?? "";

  //setter
  set mobileNo(String value) {
    _sharedPrefs!.setString(StringConstants.mobileNo, value);
  }

  set guestId(String value) {
    _sharedPrefs!.setString(StringConstants.guestId, value);
  }

  set userId(String value) {
    _sharedPrefs!.setString(StringConstants.userId, value);
  }

  set userName(String value) {
    _sharedPrefs!.setString(StringConstants.userName, value);
  }

  set guestName(String value) {
    _sharedPrefs!.setString(StringConstants.guestName, value);
  }

  set guestProfileImage(String value) {
    _sharedPrefs!.setString(StringConstants.guestProfileImage, value);
  }

  set guestIdProof(List<String> value) {
    _sharedPrefs!.setStringList(StringConstants.guestIdProof, value);
  }

  set primaryTheme(String value) {
    _sharedPrefs!.setString(StringConstants.primaryTheme, value);
  }

  set marriageId(String value) {
    _sharedPrefs!.setString(StringConstants.marriageId, value);
  }

  /*--------------- Check Is Login or Not --------------------*/
  Future<bool> isLogin() async {
    String userId = sharedPrefs.userId;
    if (userId == "" || userId.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}

final sharedPrefs = SharedPrefs();
