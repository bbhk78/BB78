import 'package:boysbrigade/controller/user_ctrl.dart';
import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/pages/group_perf.dart';
import 'package:boysbrigade/pages/sub_groups_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boysbrigade/utils.dart';

class GroupsView extends GetWidget<UserController> {
  const GroupsView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Group> sortedGroups = controller.groups..sort(
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

              return GroupCardWidget(
                group: currGroup,
                showSubGroupsView: !controller.user!.admin,
              );
            },
          )
        ],
      ),
    );
  }
}

class GroupCardWidget extends GetWidget<UserController> {
  final Group group;
  final bool showSubGroupsView;
  final RxInt numStudents = 0.obs;

  GroupCardWidget({
    Key? key,
    required this.group,
    required this.showSubGroupsView,
  }) : super(key: key);

  void updateNumStudents() {
    numStudents.value = controller.students
      .where((Student student) => student.groupId == group.id)
      .length;
  }

  @override
  Widget build(BuildContext context) {
    updateNumStudents();

    return InkWell(
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
                Obx(() => Text(
                  '# of students'.tr + numStudents.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'OpenSans SemiBold',
                  ),
                )),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: group.tileColor,
        ),
      ),
      onTap: () async {
        await Get.to<void>(
          () => showSubGroupsView
            ? SubGroupsView(group: group)
            : GroupPerformance(group: group)
        );

        updateNumStudents();
        numStudents.refresh();
      },
    );
  }
}
