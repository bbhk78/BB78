import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/pages/student_perf_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class SubGroupPerformance extends GetWidget<AuthController> {
  final Group group;
  final SubGroup subgroup;
  final Color tileColor;

  const SubGroupPerformance({
    required this.group,
    required this.subgroup,
    required this.tileColor,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    final List<Student> students = teacherCtrl.students
      .where((Student student) => student.subgroupId == subgroup.id)
      .toList();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: group.name,
        subtitle: subgroup.name,
        showBackButton: true
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: students.length,
          itemBuilder: (BuildContext context, int studIndex) {
            final Student currStudent = students[studIndex];
            return StudentPerformanceWidget(
              student: currStudent,
              tileColor: tileColor
            );
          },
        ),
      ),
    );
  }
}


