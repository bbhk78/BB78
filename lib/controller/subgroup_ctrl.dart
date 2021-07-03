import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/services/database.dart';
import 'package:get/get.dart';

class SubGroupsController extends GetxController {
  final RxList<SubGroup> _subGroupsList = <SubGroup>[].obs;
  List<SubGroup> get subGroups => _subGroupsList.toList();

  @override
  void onInit() {
    super.onInit();
    _subGroupsList.bindStream(Database.subGroupsStream());
  }
}
