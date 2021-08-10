import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  final RxList<Group> _groupsList = <Group>[].obs;
  List<Group> get groups => _groupsList.toList();

  final RxList<SubGroup> _subgroupsList = <SubGroup>[].obs;
  List<SubGroup> get subgroups => _subgroupsList.toList();

  @override
  void onInit() {
    super.onInit();

    _groupsList.bindStream(Database.groupsStream());
    _subgroupsList.bindStream(Database.subGroupsStream());
  }
}