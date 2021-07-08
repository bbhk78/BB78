import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:boysbrigade/utils.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final List<String> subGroupIds;
  final List<String> uniformClass;
  final String teacherId;

  const Group({
    required this.id,
    required this.name,
    required this.subGroupIds,
    required this.uniformClass,
    required this.teacherId,
  });

  Map<String, dynamic> toFirestore() => <String, dynamic>{
    'name': name,
    'sub-groups': subGroupIds,
    'uniform-class': uniformClass,
    'teacher': teacherId,
  };

  Group.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
    : id = document.id,
      name = document.data()!['name'] as String,
      subGroupIds = TypeUtils.parseList<String>(document.data()!['sub-groups']),
      uniformClass = TypeUtils.parseList<String>(document.data()!['uniform-class']),
      teacherId = document.data()!['teacher'] as String;

  @override
  List<Object> get props => <Object>[id, name];
}
