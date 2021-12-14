import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/note.dart';
import 'package:notes_firebase_app/data/models/task.dart';
import 'package:notes_firebase_app/screens/note_detail/note_detail.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  static Task firstSleepTask = Task("Se lever à 7h30 du matin", true);
  static Task secondSleepTask = Task("Manger son petit déjeuner à 8h", false);
  static Task thirdSleepTask = Task("Se coucher avant minuit", false);

  static Task firstSportTask =
      Task("Aller à la salle de sport 3 fois par semaine", true);
  static Task secondSportTask = Task("Courir le dimanche ou samedi", false);
  static Task thirdSportTask =
      Task("Faire de l'escalade au moins une fois", false);

  static List<Task> sleepTasks = [
    firstSleepTask,
    secondSleepTask,
    thirdSleepTask
  ];
  static List<Task> sportTasks = [
    firstSportTask,
    secondSportTask,
    thirdSportTask
  ];

  static List<Note> notes = [
    Note('Améliorer son sommeil', sleepTasks),
    Note('Faire du sport', sportTasks)
  ];

  Widget noteTile(BuildContext context, Note note) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NoteDetail()));
      },
      child: Container(
        height: 50,
        color: const Color(0xFF393939),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
          child: Text(note.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];

            return noteTile(context, note);
          },
        ),
      ),
    );
  }
}