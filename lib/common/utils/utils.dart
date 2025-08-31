import 'package:dejapew/common/enums/cards_type.dart';
import 'package:dejapew/common/storage_service/storage_keys.dart';
import 'package:dejapew/common/storage_service/storage_service.dart';

class Utils {
  static Future<CardsType> getCardType() async {
    final value = await StorageService.getString(StorageKeys.cards_type);
    if (value == CardsType.car_brands.name) {
      return CardsType.car_brands;
    } else if (value == CardsType.ios_emojies.name) {
      return CardsType.ios_emojies;
    } else {
      return CardsType.car_brands;
    }
  }

  static Future setCardType(CardsType cardsType) async {
    await StorageService.setString(StorageKeys.cards_type, cardsType.name);
  }

  static String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
