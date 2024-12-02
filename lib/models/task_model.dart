import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String name;
  DateTime createAt;
  DateTime updateAt;
  bool isUpdated;

  TaskModel({
    required this.id,
    required this.createAt,
    required this.isUpdated,
    required this.name,
    required this.updateAt,
  });
  factory TaskModel.fromJson(Map<String, dynamic> doc, String id) {
    return TaskModel(
      id: id,
      createAt: (doc['createAt'] as Timestamp).toDate(),
      updateAt: (doc['updateAt'] as Timestamp).toDate(),
      name: doc['name'],
      isUpdated: doc['isUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "createAt": createAt,
      "updateAt": updateAt,
      "isUpdated": isUpdated,
    };
  }
}
