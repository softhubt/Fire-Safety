import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  static late SharedPreferences sharedPreferences;

  static Future initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setData({
    required String dataType,
    required String prefKey,
    bool? boolData,
    double? doubleData,
    int? integerData,
    String? stringData,
    List<String>? listOfStringData,
  }) async {
    switch (dataType) {
      case "bool":
        return sharedPreferences.setBool(prefKey, boolData!);
      case "double":
        return sharedPreferences.setDouble(prefKey, doubleData!);
      case "integer":
        return sharedPreferences.setInt(prefKey, integerData!);
      case "stringType":
        return sharedPreferences.setString(prefKey, stringData!);
      case "listOfString":
        return sharedPreferences.setStringList(prefKey, listOfStringData!);
      default:
        return "Something went wrong during setting data to local storage";
    }
  }

  static getData({required String dataType, required String prefKey}) async {
    switch (dataType) {
      case "bool":
        return sharedPreferences.getBool(prefKey);
      case "double":
        return sharedPreferences.getDouble(prefKey);
      case "integer":
        return sharedPreferences.getInt(prefKey);
      case "stringType":
        return sharedPreferences.getString(prefKey);
      case "listOfString":
        return sharedPreferences.getStringList(prefKey);
      default:
        return "Something went wrong during getting data from local storage";
    }
  }

  static clearData() async {
    sharedPreferences.clear();
  }
}
