import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _data = SharedPreferences.getInstance();
Future<void> init(String key, String value) async {
  final SharedPreferences data = await _data;
  int new_value = int.parse(value);
  data.setInt('$key', new_value).then((a) => print("done"));
}

getData(String key) async {
  final SharedPreferences data = await _data;
  return data.getInt('$key');
}

del_data(String key) async {
  final SharedPreferences data = await _data;
  data.remove(key);
}
