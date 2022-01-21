import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/task.dart';
import 'add_task_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';

class NoteDetailFile extends StatefulWidget {
  const NoteDetailFile({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  State<NoteDetailFile> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetailFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pièce jointe d'une tâche"),
      ),
      body: Center(
        child: Image.network(widget.task.imageUrl!),
      ),
    );
  }
}
