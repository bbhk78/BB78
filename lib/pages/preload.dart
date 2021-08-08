import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/pages/home.dart';
import 'package:boysbrigade/pages/login.dart';

class Preload extends GetWidget<AuthController> {
  const Preload({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController teacherCtrl = Get.find<UserController>();
    final RxBool isUserReady = false.obs;

    // NOTE: We're using a status stream for properly implementing the "Remember Me"
    // functionality since the teacher data is asynchronously updated. In other words,
    // it solves the problem where the user is not null but the teacher data is not
    // fully populated by the streams.
    return StreamBuilder<UserStatus?>(
      stream: teacherCtrl.teacherStatusStream,
      builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
        isUserReady.value = controller.user?.uid != null && teacherCtrl.hasData;
        return Obx(() => isUserReady.value ? Home() : Login());
      },
    );
  }
}