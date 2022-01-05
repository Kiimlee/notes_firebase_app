import 'package:flutter/material.dart';

import 'package:notes_firebase_app/data/models/note.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({Key? key}) : super(key: key);

  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  String? noteTitle;
  String? noteId;

  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add Note'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Note Title'),
                onChanged: (text) => noteTitle = text,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                if (noteTitle != null) {
                  final newNote = Note(noteTitle!, noteTitle! + '1');
                  repository.addNote(newNote);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add')),
        ]);
  }
}
