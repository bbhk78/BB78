import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

// TODO: PLEASE REMOVE ME WHEN DONE
const bool TMP_DEBUG_FLAG = true;

class Signup extends GetWidget<AuthController> {
  Signup({ Key? key }) : super(key: key);

  // TODO: REMOVE DEFAULT TESTING VALUES
  // final RxString email = TMP_DEBUG_FLAG ? 'admin@bb78.com'.obs : ''.obs;
  // final RxString password = TMP_DEBUG_FLAG ? 'admin1234'.obs : ''.obs;

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

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
                // initialValue: email.value,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  fillColor: Colors.grey[200],
                  hintText: 'new email',
                  filled: true,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600]
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                // onChanged: (String newValue) => email.value = newValue,
                validator: ValidationBuilder()
                  .required('email required'.tr)
                  .email('invalid email'.tr)
                  .build(),
              ),
              const SizedBox(height: 15),
              TextFormField(
                // initialValue: password.value,
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
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700]
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                  ),
                ),
                // onChanged: (String newValue) => password.value = newValue,
                obscureText: true,
                validator: ValidationBuilder()
                  .required('password required'.tr)
                  .build(),
              ),
              const SizedBox(height: 30),
              RaisedButton(
                child: const Text(
                  'Signup',
                  style: TextStyle(fontSize: 16),
                ),
                shape: const RoundedRectangleBorder(),
                color: Colors.black,
                textColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20
                ),
                onPressed: () {
                  Get.back<void>();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
