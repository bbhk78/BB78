import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/services/localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

List<DropdownMenuItem<LocaleBundle>> _languageItems(LocalizationService service) =>
  service.availableLangs.map(
      (LocaleBundle value) => DropdownMenuItem<LocaleBundle>(
        value: value,
        child: Text(
          value.lang,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'OpenSans Regular',
          ),
        )
      )
  ).toList();

class Settings extends GetWidget<AuthController> {
  const Settings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalizationService localeService = Get.find<LocalizationService>();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(title: 'settings'.tr),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.help),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'about'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans SemiBold',
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
              onTap: () => Get.to<void>(() => const About()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.language),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'language'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'OpenSans SemiBold',
                    ),
                  ),
                ),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton<LocaleBundle>(
                    onChanged: (LocaleBundle? value) {
                      // NOTE: There's no reason 'value' should be a nullable string here,
                      // but dart is complaining about a type compatibility problem so meh
                      localeService.changeLocale(value!.locale);
                    },
                    value: localeService.currentLang,
                    items: _languageItems(localeService),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: TextButton(
                  onPressed: () async {
                    await controller.signOut();
                  },
                  child: Text(
                    'logout'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'OpenSans SemiBold',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class About extends StatelessWidget {
  const About({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    // TODO: add top padding to AppBar and icon
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        'about'.tr,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 25,
        ),
      ),
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              children: <Widget>[
                Text(
                  'about app description'.tr,
                  style: const TextStyle(
                    fontFamily: 'OpenSans Regular',
                    fontSize: 20
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  'about app title'.tr,
                  style: const TextStyle(
                    fontFamily: 'OpenSans Regular',
                    fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
