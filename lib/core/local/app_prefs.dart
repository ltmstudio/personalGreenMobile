import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  final _boardingScreen = "_boardingScreen";
  final _crmName = "_crmName";
  final _crmHost = "_crmHost";
  final _crmToken = "_crmToken";

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(_boardingScreen, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(_boardingScreen) ?? false;
  }

  Future<void> setCrmName(String name) async {
    await _sharedPreferences.setString(_crmName, name);
  }

  Future<String?> getCrmName() async {
    return _sharedPreferences.getString(_crmName);
  }

  Future<void> setCrmHost(String name) async {
    await _sharedPreferences.setString(_crmHost, name);
  }

  Future<String?> getCrmHost() async {
    return _sharedPreferences.getString(_crmHost);
  }

  Future<void> setCrmToken(String name) async {
    await _sharedPreferences.setString(_crmToken, name);
  }

  Future<String?> getCrmToken() async {
    log(_crmToken,name: 'getCrmToken');
    return _sharedPreferences.getString(_crmToken);
  }

  Future<bool> isCrmAvailable() async {
    String? token = _sharedPreferences.getString(_crmToken);
    String? host = _sharedPreferences.getString(_crmHost);
    return Future.value(((token != null) && (host != null)));
  }

  Future<void> clearCrm() async {
    await _sharedPreferences.remove(_crmName);
    await _sharedPreferences.remove(_crmHost);
    await _sharedPreferences.remove(_crmToken);
  }
}
