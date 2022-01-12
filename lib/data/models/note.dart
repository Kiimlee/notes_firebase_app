import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Note {
  String title;
  String id;

  Note(this.title, this.id);

  factory Note.fromJson(Map<String, dynamic> json) => _noteFromJson(json);
  factory Note.fromSnapshot(DocumentSnapshot snapshot) {
    final newNote = Note.fromJson(snapshot.data() as Map<String, dynamic>);
    newNote.id = snapshot.reference.id;
    return newNote;
  }

  Map<String, dynamic> toJson() => _noteToJson(this);

  static Map<String, dynamic> toMap(Note note) => {
        'title': note.title,
        'id': note.id,
      };

  static String encode(List<Note> notes) => json.encode(
        notes.map<Map<String, dynamic>>((note) => Note.toMap(note)).toList(),
      );

  static List<Note> decode(String notes) =>
      (json.decode(notes) as List<dynamic>)
          .map<Note>((item) => Note.fromJson(item))
          .toList();

  @override
  toString() => 'Note<$title>';
}

Note _noteFromJson(Map<String, dynamic> json) {
  return Note(json['title'] as String, json['id'] as String);
  // tasks: tasks.map((task) => Task.fromJson(task)).toList()
  // tasks: _convertTask(json['tasks'] as List<dynamic>));
}

// List<Task> _convertTask(List<dynamic> taskMap) {
//   final tasks = <Task>[];

//   for (final task in taskMap) {
//     tasks.add(Task.fromJson(task as Map<String, dynamic>));
//   }

//   return tasks;
// }

Map<String, dynamic> _noteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      // 'tasks': _tasksList(instance.tasks),
    };

// List<Map<String, dynamic>>? _tasksList(List<Task>? tasks) {
//   if (tasks == null) {
//     return null;
//   }
//   final vaccinationMap = <Map<String, dynamic>>[];
//   // ignore: avoid_function_literals_in_foreach_calls
//   tasks.forEach((task) {
//     vaccinationMap.add(task.toJson());
//   });
//   return vaccinationMap;
// }
