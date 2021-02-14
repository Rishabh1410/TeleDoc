import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _data = SharedPreferences.getInstance();

Future<void> init(String key, String value) async {
  final SharedPreferences data = await _data;
  data.setString('$key', value).then((a) => print("stored"));
}

getData(String key) async {
  final SharedPreferences data = await _data;
  return data.getString('$key');
}

del_data(String key) async {
  final SharedPreferences data = await _data;
  data.remove(key);
}
