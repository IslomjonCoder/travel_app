import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageShared {
  static SharedPreferences? _prefs;

  // Private constructor
  LocalStorageShared._();

  // Initialize SharedPreferences synchronously
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // CRUD methods for bool type
  static Future<void> setBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> removeBool(String key) async {
    return await _prefs!.remove(key);
  }

  // CRUD methods for int type
  static Future<void> setInt(String key, int value) async {
    await init();
    await _prefs!.setInt(key, value);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  static Future<bool> removeInt(String key) async {
    return await _prefs!.remove(key);
  }

  // CRUD methods for double type
  static Future<void> setDouble(String key, double value) async {
    await init();
    await _prefs!.setDouble(key, value);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  static Future<bool> removeDouble(String key) async {
    return await _prefs!.remove(key);
  }

  // CRUD methods for String type
  static Future<void> setString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  static bool hasKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  static Future<bool> removeString(String key) async {
    return await _prefs!.remove(key);
  }

  // CRUD methods for List<String> type
  static Future<void> setStringList(String key, List<String> value) async {
    await init();
    await _prefs!.setStringList(key, value);
  }

  static List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  static Future<bool> removeStringList(String key) async {
    return await _prefs!.remove(key);
  }

  // Additional method for clearing all data
  static Future<void> clearAll() async {
    await _prefs!.clear();
  }
}
