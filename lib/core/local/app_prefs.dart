import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  final _boardingScreen = "_boardingScreen";

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(_boardingScreen, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(_boardingScreen) ?? false;
  }
}
