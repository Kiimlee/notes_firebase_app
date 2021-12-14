import 'package:notes_firebase_app/data/models/task.dart';

class Note {
  String title;
  List<Task> tasks;

  Note(this.title, this.tasks);
}
