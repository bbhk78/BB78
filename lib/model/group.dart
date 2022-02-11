import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:boysbrigade/utils.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final List<String> subGroupIds;
  final List<String> uniformClass;
  final Map<String, int> attendanceInfo;
  final List<String> teacherIds;
  final int sortOrder;
  final Color tileColor;

  const Group({
    required this.id,
    required this.name,
    required this.subGroupIds,
    required this.uniformClass,
    required this.attendanceInfo,
    required this.teacherIds,
    required this.sortOrder,
    required this.tileColor,
  });

  Map<String, dynamic> toFirestore() => <String, dynamic>{
        'name': name,
        'sub-groups': subGroupIds,
        'uniform-class': uniformClass,
        'attendance-info': attendanceInfo,
        'teachers': teacherIds,
        'sort-order': sortOrder,
        'tile-color': tileColor.toString(),
      };

  Group.fromFirestore(DocumentSnapshot<Map<String, dynamic>> document)
      : id = document.id,
        name = document.data()!['name'] as String,
        subGroupIds =
            TypeUtils.parseList<String>(document.data()!['sub-groups']),
        uniformClass =
            TypeUtils.parseList<String>(document.data()!['uniform-class']),
        attendanceInfo =
            TypeUtils.parseHashMap<String, int>(document.data()!['attendance-info']),
        teacherIds = TypeUtils.parseList<String>(document.data()!['teachers']),
        sortOrder = document.data()!['sort-order'] as int,
        tileColor = Color(int.parse((document.data()!['tile-color'] as String)
            .replaceAll('#', '0xff')));

  @override
  List<Object> get props => <Object>[id, name];
}
