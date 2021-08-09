import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/pages/student_perf_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:boysbrigade/pages/manage_subgroup_students.dart';

import 'package:get/get.dart';
import 'package:boysbrigade/utils.dart';

class GroupPerformance extends GetWidget<UserController> {
  final Group group;

  const GroupPerformance({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Student> groupStudents = controller.students
      .where((Student student) => student.groupId == group.id)
      .toList();

    final List<SubGroup> subgroups = controller.subgroups
      .where((SubGroup subgroup) => subgroup.groupId == group.id)
      .toList();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: group.name,
        subtitle: '# of students'.tr + groupStudents.length.toString(),
        showBackButton: true
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subgroups.length,
          itemBuilder: (BuildContext context, int subGroupIndex) {
            final SubGroup subgroup = subgroups[subGroupIndex];
            final List<Student> subGroupStudents = controller.students
              .where((Student student) => subgroup.studentIds.contains(student.id))
              .toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      subgroup.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'OpenSans Regular'
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => Get.to<void>(
                        ManageSubGroupStudents(
                          subgroup: subgroup,
                          students: subGroupStudents
                        )
                      ),
                    )
                  ],
                ),
                const Divider(thickness: 0.5),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subGroupStudents.length,
                    itemBuilder: (BuildContext context, int studIndex) {
                      final Student currStudent = subGroupStudents[studIndex];

                      return StudentPerformanceWidget(
                        student: currStudent,
                        tileColor: group.tileColor
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
