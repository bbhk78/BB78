import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';
import 'package:boysbrigade/pages/sub_group_perf.dart';

class SubGroupsView extends GetWidget<AuthController> {
  final Group group;
  final Color tileColor;

  const SubGroupsView({
    Key? key,
    required this.group,
    required this.tileColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();
    final List<SubGroup> filteredSubGroups = teacherCtrl.subgroups.where(
      (SubGroup subgroup) => subgroup.groupId == group.id
    ).toList();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: group.name,
        subtitle: '# of students'.tr + teacherCtrl.students
          .where((Student student) => student.groupId == group.id)
          .length.toString(),
        showBackButton: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              itemCount: filteredSubGroups.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final SubGroup currSubGroup = filteredSubGroups[index];
                final int numStudents = teacherCtrl.students
                  .where((Student student) => student.subgroupId == currSubGroup.id)
                  .length;

                return SubGroupCardWidget(
                  group: group,
                  subgroup: currSubGroup,
                  tileColor: tileColor,
                  numStudents: numStudents
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


class SubGroupCardWidget extends StatelessWidget {
  final Group group;
  final SubGroup subgroup;
  final Color tileColor;
  final int numStudents;

  const SubGroupCardWidget({
    required this.group,
    required this.subgroup,
    required this.tileColor,
    required this.numStudents,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            subgroup.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'OpenSans SemiBold',
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '# of students'.tr + numStudents.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'OpenSans SemiBold',
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: tileColor,
      ),
    ),
    onTap: () => Get.to<void>(
      () => SubGroupPerformance(
        group: group,
        subgroup: subgroup,
        tileColor: tileColor
      )
    ),
  );
}
