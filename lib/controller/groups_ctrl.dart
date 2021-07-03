import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  final RxList<Group> _groupsList = <Group>[].obs;
  List<Group> get groups => _groupsList.toList();

  @override
  void onInit() {
    super.onInit();
    _groupsList.bindStream(Database.groupsStream());
  }
}
