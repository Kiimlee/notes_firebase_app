import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../data/models/note.dart';

class DataRepository {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addNote(Note note) {
    return collection.add(note.toJson());
  }

  void updateNote(Note note) async {
    await collection.doc(note.id).update(note.toJson());
  }

  void deleteNNote(Note note) async {
    await collection.doc(note.id).delete();
  }
}
