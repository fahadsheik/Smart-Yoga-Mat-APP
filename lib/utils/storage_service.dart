import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods for sensitive data
  Future<void> secureWrite(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> secureRead(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> secureDelete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> secureClear() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences Methods for non-sensitive data
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}

final storageService = StorageService();