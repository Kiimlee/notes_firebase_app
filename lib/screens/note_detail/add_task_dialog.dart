import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/task.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key, required this.noteId}) : super(key: key);

  final String noteId;

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String? title;
  bool done = false;

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
                onChanged: (text) => title = text,
              ),
              Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.blue),
                  value: done,
                  onChanged: (bool? value) {
                    setState(() {
                      done = value ?? false;
                    });
                  }),
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
                if (title != null) {
                  final newtask = Task(title!, done, title! + "1");
                  repository.addTask(widget.noteId, newtask);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add')),
        ]);
  }
}
