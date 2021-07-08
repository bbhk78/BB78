import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/services/localization.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/controller/groups_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';

import 'package:boysbrigade/constants/langs.dart';

import 'controller/subgroup_ctrl.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get
      ..put<LocalizationService>(LocalizationService(
        supportedLanguages: LangConstants.SUPPORTED_LOCALES,
        defaultLocale: LangConstants.DEFAULT_LOCALE,
        fallbackLocale: LangConstants.FALLBACK_LOCALE,
      ), permanent: true)
      ..put<AuthController>(AuthController(), permanent: true)
      ..put<GroupsController>(GroupsController(), permanent: true)
      ..put<SubGroupsController>(SubGroupsController(), permanent: true)
      ..put<TeacherController>(TeacherController(), permanent: true);
  }
}
