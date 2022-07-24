import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance;
  }

  static Future<bool> getBool(String key) async {
    var prefs = await _instance;
    return prefs.getBool(key) ?? false;
  }

  static Future setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool getBooll(String key) => _prefsInstance!.getBool(key) ?? false;

  static String getString(String key, [String? defValue]) {
    return _prefsInstance!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static String getInt(String key, [String? defValue]) {
    return _prefsInstance!.getInt(key) as String? ?? defValue ?? 0 as String;
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefsInstance!.setStringList(key, value);

  static List<String>? getStringList(String key) =>
      _prefsInstance!.getStringList(key);

  static void clear() {
    _prefsInstance!.clear();
  }

  static Future<bool?> setlogin(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool? getlogin(String key, [bool? defValue]) {
    return _prefsInstance!.getBool(key) ?? defValue;
  }

  static Future<bool?> setstatus(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool? getstatus(String key, [bool? defValue]) {
    return _prefsInstance!.getBool(key) ?? defValue;
  }

  static Future<bool?> setnotification(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool? getnotification(String key, [bool? defValue]) {
    return _prefsInstance!.getBool(key) ?? defValue;
  }

  static Future<bool?> setverify(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool? getverify(String key, [bool? defValue]) {
    return _prefsInstance!.getBool(key) ?? defValue;
  }
}
