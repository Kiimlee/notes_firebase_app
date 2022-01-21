import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/task.dart' as Taski;
import 'package:notes_firebase_app/repository/data_repository.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key, required this.noteId}) : super(key: key);

  final String noteId;

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final DataRepository repository = DataRepository();

  String? title;
  bool done = false;

  UploadTask? task;
  File? file;

  bool isUploadingFile = false;

  Future uploadFile() async {
    isUploadingFile = true;
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = DataRepository.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() => {});
    var urlImage = await snapshot.ref.getDownloadURL();
    final newTask = Taski.Task(title!, done, title! + "1", urlImage);
    repository.addTask(widget.noteId, newTask);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text('$percentage %');
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final fileName =
        file != null ? basename(file!.path) : 'Aucun fichier sélectionner';

    return AlertDialog(
        title: const Text('Ajouter une tâche'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Note Title'),
                onChanged: (text) => title = text,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                  onPressed: () => selectFile(),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Sélectionner un fichier')),
              const SizedBox(height: 8),
              Text(fileName),
              const SizedBox(height: 8),
              task != null ? buildUploadStatus(task!) : Container(),
              Row(children: [
                Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    value: done,
                    onChanged: (bool? value) {
                      setState(() {
                        done = value ?? false;
                      });
                    }),
                const Text('Terminée'),
              ])
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler')),
          TextButton(
              onPressed: () {
                if (title != null) {
                  final newTask = Taski.Task(title!, done, title! + "1", null);
                  if (file != null) {
                    uploadFile();
                  } else {
                    repository.addTask(widget.noteId, newTask);
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Ajouter')),
        ]);
  }
}
