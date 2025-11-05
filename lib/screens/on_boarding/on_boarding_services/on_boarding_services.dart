import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingServices {
  static late SharedPreferences sharedPrefs;

  static Future initializeSharedPrefrencesStorage() async {
    sharedPrefs = await SharedPreferences.getInstance();
  }

  static bool isFirstTime() {
    bool isFirstTime = sharedPrefs.getBool('isFirstTime') ?? true;
    return isFirstTime;
  }

  static setFirstTimeWithFalse() {
    sharedPrefs.setBool('isFirstTime', false);
  }

  static setFirstTimeWithTrue() {
    sharedPrefs.setBool('isFirstTime', true);
  }
}