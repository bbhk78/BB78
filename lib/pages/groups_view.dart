import 'package:boysbrigade/constants/ui.dart';
import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/pages/group_perf.dart';
import 'package:boysbrigade/pages/sub_groups_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class GroupsView extends GetWidget<AuthController> {
  const GroupsView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController teacherCtrl = Get.find<UserController>();
    final List<Group> sortedGroups = teacherCtrl.groups..sort(
      (Group a, Group b) => a.sortOrder.compareTo(b.sortOrder)
    );

    return Scaffold(
      appBar: GuiUtils.simpleAppBar(
        title: 'half year'.tr,
        subtitle: DateTime.now().month < 7
          ? 'first half year'.tr
          : 'second half year'.tr
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GridView.builder(
            padding: const EdgeInsets.all(30),
            shrinkWrap: true,
            itemCount: sortedGroups.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Group currGroup = sortedGroups[index];
              final int numStudents = teacherCtrl.students
                .where((Student student) => student.groupId == currGroup.id)
                .length;

              return GroupCardWidget(
                group: currGroup,
                numStudents: numStudents,
                showSubGroupsView: !teacherCtrl.user!.admin,
              );
            },
          )
        ],
      ),
    );
  }
}

class GroupCardWidget extends StatelessWidget {
  final Group group;
  // final Color tileColor;
  final int numStudents;
  final bool showSubGroupsView;

  const GroupCardWidget({
    Key? key,
    required this.group,
    // required this.tileColor,
    required this.numStudents,
    required this.showSubGroupsView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
        color: group.tileColor,
      ),
    ),
    onTap: () => Get.to<void>(
      () => showSubGroupsView
        ? SubGroupsView(group: group)
        : GroupPerformance(group: group)
    ),
  );
}
