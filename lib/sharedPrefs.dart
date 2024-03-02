import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late final SharedPreferences _sharedPrefs;

  static final SharedPrefs _instance = SharedPrefs._internal();

  factory SharedPrefs() => _instance;

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

/*  int get themeMode => _sharedPrefs.getInt("themeMode") ?? 2;

  set themeMode(int newValue) {
    _sharedPrefs.setInt("themeMode", newValue);
  }*/

  bool get isWorking => _sharedPrefs.getBool("isWorking") ?? false;

  set isWorking(bool newValue){
    _sharedPrefs.setBool("isWorking", newValue);
  }

  int get startTime => _sharedPrefs.getInt("startTime") ?? 0;

  set startTime(int newValue){
    _sharedPrefs.setInt("startTime", newValue);
  }

  String get workTitle => _sharedPrefs.getString("workTitle") ?? "";

  set workTitle(String newValue){
    _sharedPrefs.setString("workTitle", newValue);
  }

}
