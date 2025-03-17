import 'dart:ui';

import 'package:flutter_application_1/localization/en/english_translation.dart';
import 'package:flutter_application_1/localization/np/nepali_translation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends Translations {
  // Prevent creating instance
  LocalizationService._();

  static LocalizationService? _instance;

  static LocalizationService getInstance() {
    _instance ??= LocalizationService._();
    return _instance!;
  }

  // Default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // Supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', ''),
    'np': const Locale('np', ''),
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'np': np,
      };

  /// Check if the language is supported
  static bool isLanguageSupported(String languageCode) =>
      supportedLanguages.keys.contains(languageCode);

  // Initialize GetStorage
  static final _storage = GetStorage();

  /// Update app language by code language (for example: en, ar)
  static updateLanguage(String languageCode) async {
    // Check if the language is supported
    if (!isLanguageSupported(languageCode)) return;

    // Update current language in GetStorage
    await _storage.write('currentLanguage', languageCode);

    print('Current language : $languageCode');

    Get.updateLocale(supportedLanguages[languageCode]!);
  }

  /// Check if the language is English
  static bool isItEnglish() {
    return _storage.read('currentLanguage')?.toLowerCase().contains('en') ??
        false;
  }

  /// Get current locale
  static Locale getCurrentLocal() {
    final languageCode = _storage.read('currentLanguage') ?? 'en';
    return supportedLanguages[languageCode]!;
  }
}
