import 'package:boysbrigade/constants/data.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class Signup extends GetWidget<AuthController> {
  Signup({Key? key}) : super(key: key);

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<String?> attemptLogin(String email, String password) async {
    String? errMessage;
    try {
      await controller.loginTeacher(email, password);

      final UserController userCtrl = Get.find<UserController>()
        ..readonly = true;

      // HACK: This delayed checking loop is so that the rest of the teacher
      // data has time to load in before we render the home page.

      // This also "solves" the issue where the user has *just* logged in
      // but the teacher data isn't loaded in as of yet.

      // NOTE: This is most probably a bad practice, but it works for now
      await FutureUtils.waitFor(
          () => userCtrl.hasData, const Duration(milliseconds: 50));
      errMessage = null;
    } on FirebaseAuthException catch (err) {
      errMessage = err.message ?? 'Unknown error code: ${err.code}!';
    } on Exception catch (err) {
      errMessage = err.toString();
    }

    return errMessage;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 50, 40, 0),
            child: Form(
              key: loginFormKey,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/logo.png',
                    height: 180,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey[200],
                      hintText: 'new email',
                      filled: true,
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationBuilder()
                        .required('email required'.tr)
                        .email('invalid email'.tr)
                        .build(),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'new password',
                      hintStyle:
                          TextStyle(fontSize: 16, color: Colors.grey[700]),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    obscureText: true,
                    validator: ValidationBuilder()
                        .required('password required'.tr)
                        .build(),
                  ),
                  const SizedBox(height: 30),
                  RaisedButton(
                    child: Text(
                      'signup'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                    shape: const RoundedRectangleBorder(),
                    color: Colors.black,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        final String? errMessage =
                        await Get.dialog<String?>(FutureProgressDialog(
                          attemptLogin(TEST_EMAIL, TEST_PASSWORD),
                          message: Text('loading'.tr),
                        ));

                        if (errMessage != null) {
                          Get.rawSnackbar(
                              title: 'login failed'.tr, message: errMessage);
                        } else {
                          Get.back<void>();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
