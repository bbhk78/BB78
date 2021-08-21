import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class ManageSubGroupStudents extends GetWidget<UserController> {
  final SubGroup subgroup;
  final RxList<Student> students = <Student>[].obs;

  ManageSubGroupStudents({Key? key, required this.subgroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    students.value = controller.students
        .where((Student student) => student.subgroupId == subgroup.id)
        .toList()
          ..sort((Student a, Student b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'attendance'.tr,
        subtitle: DateTimeHelper.today().formatted('dd/MM/yyyy'),
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() => ListView(
                    padding: const EdgeInsets.only(bottom: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            subgroup.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              final TextEditingController addStudentTextCtrl =
                                  TextEditingController.fromValue(
                                      TextEditingValue.empty);

                              await Get.defaultDialog<void>(
                                title: 'add new student'.tr,
                                titlePadding: const EdgeInsets.only(top: 8),
                                content: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: TextField(
                                    controller: addStudentTextCtrl,
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                                radius: 0,
                                textConfirm: 'ok'.tr,
                                textCancel: 'cancel'.tr,
                                barrierDismissible: false,
                                confirmTextColor: Colors.black,
                                cancelTextColor: Colors.black,
                                buttonColor: Colors.grey.shade300,
                                onConfirm: () async {
                                  final String newStudentName =
                                      addStudentTextCtrl.value.text;
                                  Get.back<void>();

                                  await Get.dialog<void>(FutureProgressDialog(
                                    (() async {
                                      final Student? possibleStudent =
                                          await controller.addStudent(
                                              groupId: subgroup.groupId,
                                              subgroupId: subgroup.id,
                                              name: newStudentName);

                                      if (possibleStudent != null) {
                                        students
                                          ..add(possibleStudent)
                                          ..sort((Student a, Student b) =>
                                              a.name.compareTo(b.name))
                                          ..refresh();
                                      }
                                    })(),
                                    message: Text('saving data'.tr),
                                  ));
                                },
                              );
                            },
                          )
                        ],
                      ),
                      const Divider(thickness: 0.5),
                      ListView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (BuildContext context, int studentIndex) {
                          final Student currStudent = students[studentIndex];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  currStudent.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              IconButton(
                                alignment: FractionalOffset.center,
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                onPressed: () async {
                                  await Get.defaultDialog<void>(
                                    title: 'remove existing student'.tr,
                                    middleText: currStudent.name,
                                    radius: 0,
                                    textConfirm: 'ok'.tr,
                                    textCancel: 'cancel'.tr,
                                    barrierDismissible: false,
                                    confirmTextColor: Colors.black,
                                    cancelTextColor: Colors.black,
                                    buttonColor: Colors.grey.shade300,
                                    onConfirm: () async {
                                      Get.back<void>();

                                      await Get.dialog<void>(
                                          FutureProgressDialog(
                                        (() async {
                                          await controller
                                              .removeStudent(currStudent);

                                          students
                                            ..remove(currStudent)
                                            ..sort((Student a, Student b) =>
                                                a.name.compareTo(b.name))
                                            ..refresh();
                                        })(),
                                        message: Text('saving data'.tr),
                                      ));
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      )
                    ]))),
      ),
    );
  }
}
