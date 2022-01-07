import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_firebase_app/data/models/task.dart';
import '../data/models/note.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Stream<QuerySnapshot> getStreamDetail(String id) {
    return collection.doc(id).collection('tasks').snapshots();
  }

  Future<DocumentReference> addNote(Note note) {
    return collection.add(note.toJson());
  }

  Future<DocumentReference> addTask(String noteId, Task task) {
    return collection.doc(noteId).collection('tasks').add(task.toJson());
  }

  void updateNote(Note note) async {
    await collection.doc(note.id).update(note.toJson());
  }

  void deleteNote(Note note) async {
    await collection.doc(note.id).delete();
  }

  void updateTask(String noteId, Task task) async {
    await collection
        .doc(noteId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toJson());
  }

  void updateTasks(String id, List<Task> tasks) async {
    await collection.doc(id).set({"tasks": tasks});
  }

  void deleteTask(String noteId, Task task) async {
    await collection.doc(noteId).collection('tasks').doc(task.id).delete();
  }
}