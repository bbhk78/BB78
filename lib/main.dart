import 'package:boysbrigade/pages/splash_screen.dart';
import 'package:boysbrigade/pages/preload.dart';
import 'package:boysbrigade/services/localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/global_bindings.dart';

import 'package:boysbrigade/constants/langs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force initialize translations with device locale
  if (Get.locale == null)
    Get.updateLocale(Get.deviceLocale!);

  // Initialize Firebase services
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white
    ),
    initialBinding: GlobalBindings(),
    debugShowCheckedModeBanner: false,
    translations: LocalizationTranslations(LangConstants.SUPPORTED_LOCALES),
    home: FutureBuilder<void>(
      future: Future<void>.delayed(SPLASH_SCREEN_DURATION),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        final bool isLoading = snapshot.connectionState != ConnectionState.done;
        return isLoading ? const SplashScreen() : const Preload();
      },
    ),
  );
}
