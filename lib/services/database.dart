import 'package:boysbrigade/model/group.dart';
import 'package:boysbrigade/model/student.dart';
import 'package:boysbrigade/model/subgroup.dart';
import 'package:boysbrigade/model/teacher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Future<Teacher?> getTeacherByEmail(String email) async {
    final QuerySnapshot<Map<String, dynamic>> doc = await _firestore
      .collection(TEACHERS_COLL)
      .where('email', isEqualTo: email)
      .get();

    return doc.docs.isNotEmpty ? Teacher.fromFirestore(doc.docs.first) : null;
  }

  static Future<Teacher?> getTeacherById(String id) async {
    final QuerySnapshot<Map<String, dynamic>> doc = await _firestore
        .collection(TEACHERS_COLL)
        .where('id', isEqualTo: id)
        .get();

    return doc.docs.isNotEmpty ? Teacher.fromFirestore(doc.docs.first) : null;
  }

  static Future<List<Teacher>> getTeachersByIds(List<String> ids) async {
    final QuerySnapshot<Map<String, dynamic>> qs = await _firestore
        .collection(TEACHERS_COLL)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    if (qs.docs.isEmpty)
      return <Teacher>[];

    return qs.docs.map<Teacher>(
      (QueryDocumentSnapshot<Map<String, dynamic>> doc) => Teacher.fromFirestore(doc)
    ).toList();
  }

  static Future<void> saveTeacher(Teacher teacher) async {
    await _firestore
        .collection(TEACHERS_COLL)
        .doc(teacher.id)
        .set(teacher.toFirestore());
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

  static Future<bool> createStudent(Student student) async {
    try {
      await _firestore.collection(STUDENTS_COLL)
        .doc(student.id)
        .set(student.toFirestore());
      
      await _firestore.collection(SUBGROUPS_COLL)
        .doc(student.subgroupId)
        .update(<String, Object>{
          'students': FieldValue.arrayUnion(<String>[student.id])
        });

      return true;
    } on Exception {
      return false;
    }
  }

  static Future<void> saveStudent(Student student) async {
    await _firestore
      .collection(STUDENTS_COLL)
      .doc(student.id)
      .set(student.toFirestore());
  }

  static Future<bool> removeStudent(Student student) async {
    try {
      await _firestore.collection(STUDENTS_COLL)
          .doc(student.id)
          .delete();

      await _firestore.collection(SUBGROUPS_COLL)
          .doc(student.subgroupId)
          .update(<String, Object>{
            'students': FieldValue.arrayRemove(<String>[student.id])
          });

      return true;
    } on Exception {
      return false;
    }
  }

  ///////////////////////
  // END OF STUDENTS //
  ///////////////////////
}