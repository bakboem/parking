import 'package:shared_preferences/shared_preferences.dart';

class CacheObjectService {
  // -------start singleton -----------
  factory CacheObjectService() => _sharedInstance();
  static CacheObjectService? _instance;
  CacheObjectService._() {
    //
  }
  static CacheObjectService _sharedInstance() {
    if (_instance == null) {
      _instance = CacheObjectService._();
    }
    return _instance!;
  }

//  ---------end singleton -------------

  saveData<T>(String key, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        prefs.setString(key, value as String);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
    }
  }

  Future<T> getData<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    T? data;
    switch (T) {
      case String:
        data = prefs.getString(key) as T;
        break;
      case int:
        data = prefs.getInt(key) as T;
        break;
      case bool:
        data = prefs.getBool(key) as T;
        break;
      case double:
        data = prefs.getDouble(key) as T;
        break;
    }
    return data!;
  }

  Future<bool> deleteData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key).then((isSuccess) => isSuccess);
  }
}
