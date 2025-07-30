import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _prefs;
  static const _cacheExpiryMinutes = 30;

  CacheHelper(this._prefs);

  Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  dynamic getData(String key) {
    return _prefs.get(key);
  }

  Future<bool> removeData(String key) async {
    return await _prefs.remove(key);
  }

  bool isCacheValid(String key) {
    final lastCacheTime = _prefs.getInt('${key}_time');
    if (lastCacheTime == null) return false;

    final cacheAge = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(lastCacheTime),
    );
    return cacheAge.inMinutes <= _cacheExpiryMinutes;
  }
}
