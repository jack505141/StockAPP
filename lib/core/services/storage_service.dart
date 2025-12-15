import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

/// Storage service for local data persistence
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Save int value
  Future<bool> saveInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Save bool value
  Future<bool> saveBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Save list of strings
  Future<bool> saveStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// Get list of strings
  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Save JSON object
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    return await saveString(key, jsonEncode(json));
  }

  /// Get JSON object
  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Clear all data
  Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// Get favorite stocks
  List<String> getFavoriteStocks() {
    return getStringList(StorageKeys.favoriteStocks) ?? [];
  }

  /// Save favorite stocks
  Future<bool> saveFavoriteStocks(List<String> stockIds) async {
    return await saveStringList(StorageKeys.favoriteStocks, stockIds);
  }

  /// Add to favorites
  Future<bool> addToFavorites(String stockId) async {
    final favorites = getFavoriteStocks();
    if (!favorites.contains(stockId)) {
      favorites.add(stockId);
      return await saveFavoriteStocks(favorites);
    }
    return true;
  }

  /// Remove from favorites
  Future<bool> removeFromFavorites(String stockId) async {
    final favorites = getFavoriteStocks();
    favorites.remove(stockId);
    return await saveFavoriteStocks(favorites);
  }
}
