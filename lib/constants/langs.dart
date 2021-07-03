import 'package:boysbrigade/utils.dart';
import 'package:boysbrigade/constants/langs/en_us.dart';
import 'package:boysbrigade/constants/langs/zh_tw.dart';

class LangConstants {
  static const List<LocaleBundle> SUPPORTED_LOCALES = <LocaleBundle>[
    EN_US_BUNDLE, ZH_TW_BUNDLE
  ];

  static const LocaleBundle DEFAULT_LOCALE = EN_US_BUNDLE;
  static const LocaleBundle FALLBACK_LOCALE = EN_US_BUNDLE;
}
