import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String contentMessage;
  bool isChecked;
  String id;
  String? imageUrl;

  Task(this.contentMessage, this.isChecked, this.id, this.imageUrl);

  factory Task.fromJson(Map<String, dynamic> json) => _taskFromJson(json);
  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    final newTask = Task.fromJson(snapshot.data() as Map<String, dynamic>);
    newTask.id = snapshot.reference.id;
    return newTask;
  }

  Map<String, dynamic> toJson() => _taskToJson(this);
}

Task _taskFromJson(Map<String, dynamic> json) {
  return Task(json['contentMessage'] as String, json['isChecked'] as bool,
      json['id'] as String, json['imageUrl'] as String);
}

Map<String, dynamic> _taskToJson(Task instance) => <String, dynamic>{
      'contentMessage': instance.contentMessage,
      'isChecked': instance.isChecked,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
    };
