import 'package:dejapew/common/enums/cards_type.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/storage_service/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static init() async {
    if (await StorageService.get(StorageKeys.cards_type) == null) {
      await StorageService.setString(
        StorageKeys.cards_type,
        CardsType.ios_emojies.name,
      );
    }

    var vol = await StorageService.getDouble(StorageKeys.sound_volume);
    if (vol == null) {
      await StorageService.setDouble(StorageKeys.sound_volume, 50);
    } else {
      SoundManager.volume = vol;
    }

    var mute = await StorageService.getBool(StorageKeys.sound_mute);
    if (mute == null) {
      await StorageService.setBool(StorageKeys.sound_mute, false);
    } else {
      SoundManager.volume = mute ? 0 : vol ?? 100;
    }
  }

  static Future<dynamic> get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
