import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';
import 'package:boysbrigade/pages/sub_group_perf.dart';

class SubGroupsView extends GetWidget<UserController> {
  final Group group;

  const SubGroupsView({
    Key? key,
    required this.group
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SubGroup> filteredSubGroups = controller.subgroups.where(
      (SubGroup subgroup) => subgroup.groupId == group.id
    ).toList();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: group.name,
        subtitle: '# of students'.tr + controller.students
          .where((Student student) => student.groupId == group.id)
          .length.toString(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GridView.builder(
              padding: const EdgeInsets.all(30),
              shrinkWrap: true,
              itemCount: filteredSubGroups.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final SubGroup currSubGroup = filteredSubGroups[index];
                final int numStudents = controller.students
                  .where((Student student) => student.subgroupId == currSubGroup.id)
                  .length;

                return SubGroupCardWidget(
                  group: group,
                  subgroup: currSubGroup,
                  tileColor: group.tileColor,
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
