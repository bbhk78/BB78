import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:boysbrigade/utils.dart';

class SubGroup extends Equatable {
  final String id;
  final String name;
  final String groupId;
  final List<String> studentIds;

  const SubGroup({
    required this.id,
    required this.name,
    required this.groupId,
    required this.studentIds,
  });

  Map<String, dynamic> toFirestore() =>
      <String, dynamic>{'name': name, 'group': groupId, 'students': studentIds};

  SubGroup.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
      : id = document.id,
        name = document.data()!['name'] as String,
        groupId = document.data()!['group'] as String,
        studentIds = TypeUtils.parseList<String>(document.data()!['students']);

  @override
  List<Object> get props => <Object>[id, name];
}
