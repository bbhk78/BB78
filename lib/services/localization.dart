import 'dart:ui';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart' show LocaleBundle;

// Source: https://iisprey.medium.com/change-your-app-language-dynamically-with-getx-in-flutter-75876db76aed

class LocalizationTranslations extends Translations {
  final List<LocaleBundle> supportedLangs;
  LocalizationTranslations(this.supportedLangs);

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
    for (LocaleBundle bundle in supportedLangs) bundle.locale.toString() : bundle.trMap
  };
}

class LocalizationService extends GetxController {
  final List<LocaleBundle> supportedLanguages;
  late LocaleBundle defaultLang, currentLang, fallbackLang;
  late LocalizationTranslations translations;

  List<LocaleBundle> get availableLangs => supportedLanguages;
  List<Locale> get availableLocales => availableLangs.map<Locale>((LocaleBundle bundle) => bundle.locale).toList();
  Locale get defaultLocale => currentLang.locale;
  Locale get fallbackLocale => fallbackLang.locale;

  LocalizationService({
    required this.supportedLanguages,
    required LocaleBundle defaultLocale,
    required LocaleBundle fallbackLocale,
  }) {
    translations = LocalizationTranslations(supportedLanguages);

    defaultLang = supportedLanguages.firstWhere(
      (LocaleBundle lang) => lang == defaultLocale,
      orElse: () => throw Exception('Default locale not part of supported locales: $defaultLocale')
    );

    fallbackLang = supportedLanguages.firstWhere(
      (LocaleBundle lang) => lang == fallbackLocale,
      orElse: () => throw Exception('Fallback locale not part of supported locales: $fallbackLocale')
    );

    currentLang = defaultLang;
  }

  void changeLocale(Locale newLocale) {
    final LocaleBundle existingBundle = availableLangs.firstWhere(
      (LocaleBundle bundle) => bundle.locale == newLocale,
      orElse: () => currentLang
    );

    if (existingBundle != currentLang) {
      currentLang = existingBundle;
      Get.updateLocale(existingBundle.locale);
    }
  }
}