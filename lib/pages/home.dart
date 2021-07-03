import 'package:boysbrigade/controller/auth_ctrl.dart';
import 'package:boysbrigade/controller/teacher_ctrl.dart';
import 'package:boysbrigade/pages/attendance.dart';
import 'package:boysbrigade/pages/day.dart';
import 'package:boysbrigade/pages/half_year.dart';
import 'package:boysbrigade/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Widget showTab(int index) {
  switch (index) {
    case 0: return const HalfYear();
    case 1: return const Day();
    case 2: return const Settings();
    default: throw Exception('Invalid index provided for bottom tab navigation: $index');
  }
}

class Home extends GetWidget<AuthController> {
  final int startIndex;
  final RxInt selectedTab = 0.obs;

  Home({ Key? key, this.startIndex = 0}) : super(key: key) {
    selectedTab.value = startIndex;
  }

  @override
  Widget build(BuildContext context) {
    final TeacherController teacherCtrl = Get.find<TeacherController>();

    return Obx(() => Scaffold(
      body: Center(
        child: showTab(selectedTab.value)
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab.value,
        onTap: (int index) => selectedTab.value = index,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400],
        iconSize: 45,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'half year'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.schedule),
            label: 'day'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: 'settings'.tr,
          ),
        ],
      ),
      floatingActionButton: (selectedTab.value == 0 && !teacherCtrl.teacher!.admin)
        ? const AddAttendanceFab()
        : null,
    ));
  }
}

class AddAttendanceFab extends StatelessWidget {
  const AddAttendanceFab({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    height: 75,
    width: 75,
    child: FloatingActionButton(
      onPressed: () => Get.to<void>(() => const AddAttendance()),
      child: const Icon(Icons.add_rounded, size: 50),
      backgroundColor: Colors.black,
      elevation: 0,
    ),
  );
}