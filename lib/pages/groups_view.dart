import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/pages/sub_groups_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class GroupsView extends GetWidget<AuthController> {
  const GroupsView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'half year'.tr,
        subtitle: DateTime.now().month < 7
          ? 'first half year'.tr
          : 'second half year'.tr
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GridView.builder(
              shrinkWrap: true,
              itemCount: teacherCtrl.groups.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final Group currGroup = teacherCtrl.groups[index];
                final Color currTileColor = HALF_YEAR_TILE_COLORS[index % HALF_YEAR_TILE_COLORS.length];
                final int numStudents = teacherCtrl.students
                  .where((Student student) => student.groupId == currGroup.id)
                  .length;

                return GroupCardWidget(
                  group: currGroup,
                  tileColor: currTileColor,
                  numStudents: numStudents,
                  showSubGroupsView: true,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


class GroupCardWidget extends StatelessWidget {
  final Group group;
  final Color tileColor;
  final int numStudents;
  final bool showSubGroupsView;

  const GroupCardWidget({
    Key? key,
    required this.group,
    required this.tileColor,
    required this.numStudents,
    required this.showSubGroupsView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            group.name,
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
    onTap: () => Get.to<void>(() => SubGroupsView(group)),
  );
}
