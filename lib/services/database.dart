import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Database {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String GROUPS_COLL = 'groups-v2';
  static const String SUBGROUPS_COLL = 'subgroups-v2';
  static const String TEACHERS_COLL = 'teachers-v2';
  static const String STUDENTS_COLL = 'students-v2';

  /////////////////////
  // START OF GROUPS //
  /////////////////////

  static Stream<List<Group>> groupsStream() => _firestore
    .collection(GROUPS_COLL)
    .snapshots()
    .map((QuerySnapshot<Map<String, dynamic>> query) =>
      query.docs.map<Group>((QueryDocumentSnapshot<Map<String, dynamic>> element) =>
        Group.fromFirestore(element)
      ).toList()
    );

  /////////////////////////
  // START OF SUB-GROUPS //
  /////////////////////////

  static Stream<List<SubGroup>> subGroupsStream() => _firestore
      .collection(SUBGROUPS_COLL)
      .snapshots()
      .map((QuerySnapshot<Map<String, dynamic>> query) =>
        query.docs.map<SubGroup>((QueryDocumentSnapshot<Map<String, dynamic>> element) =>
          SubGroup.fromFirestore(element)
      ).toList()
  );

  ///////////////////////
  // START OF TEACHERS //
  ///////////////////////

  static Future<bool> createTeacher(Teacher teacher) async {
    try {
      await _firestore.collection(TEACHERS_COLL)
        .doc(teacher.id)
        .set(teacher.toFirestore());
      return true;
    } on Exception catch (err) {
      return false;
    }
  }

  static Future<Teacher?> getTeacher(String email) async {
    final QuerySnapshot<Map<String, dynamic>> doc = await _firestore
      .collection(TEACHERS_COLL)
      .where('email', isEqualTo: email)
      .get();

    return doc.docs.isNotEmpty ? Teacher.fromFirestore(doc.docs.first) : null;
  }

  static Future<void> changeTeacherGroup(String id, String newGroupId) async {
    final List<Group> allGroups = await Database.groupsStream().first;
    final bool groupExists = allGroups
      .map((Group group) => group.id)
      .contains(newGroupId);

    if (groupExists) {
      await _firestore.collection(TEACHERS_COLL)
        .doc(id)
        .update(<String, String>{'group': newGroupId});
    } else
      throw Exception('group not found'.tr);
  }

  ///////////////////////
  // START OF STUDENTS //
  ///////////////////////

  static Stream<List<Student>> studentsStream(String? targetGroupId) {
    Query<Map<String, dynamic>> initialQuery = _firestore.collection(STUDENTS_COLL);
    if (targetGroupId != null)
      initialQuery = initialQuery.where('group', isEqualTo: targetGroupId);

    return initialQuery.snapshots()
      .map((QuerySnapshot<Map<String, dynamic>> query) =>
        query.docs.map<Student>(
          (QueryDocumentSnapshot<Map<String, dynamic>> qs) => Student.fromFirestore(qs)
        ).toList()
      );
  }

  static Future<void> saveStudent(Student student) async {
    await _firestore
      .collection(STUDENTS_COLL)
      .doc(student.id)
      .set(student.toFirestore());
  }

  ///////////////////////
  // END OF STUDENTS //
  ///////////////////////
}