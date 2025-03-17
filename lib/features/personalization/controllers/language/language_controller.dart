import 'package:get/get.dart';

import '../../../../localization/localization_service.dart';

class LanguageController extends GetxController {
  static LanguageController get instance => Get.find();
  // Observable to track language change
  RxBool isEnglish = true.obs;

  // Function to update the language
  Future<void> updateLanguage(String newLanguageCode) async {
    await LocalizationService.updateLanguage(newLanguageCode);
    Get.updateLocale(LocalizationService.getCurrentLocal());
    // Update the reactive variable after updating the locale
    isEnglish.value = newLanguageCode == 'en';
  }
}
