import 'package:notes_firebase_app/data/models/task.dart';

class Note {
  String title;
  List<Task> tasks;

  Note(this.title, {required this.tasks});

  factory Note.fromJson(Map<String, dynamic> json) => _noteFromJson(json);

  Map<String, dynamic> toJson() => _noteToJson(this);

  @override
  toString() => 'Note<$title>';
}

Note _noteFromJson(Map<String, dynamic> json) {
  var tasks = json['tasks'] as List;

  return Note(json['title'] as String,
      tasks: tasks.map((task) => Task.fromJson(task)).toList());
}

Map<String, dynamic> _noteToJson(Note instance) => <String, dynamic>{};
