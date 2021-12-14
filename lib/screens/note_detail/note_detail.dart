import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/task.dart';

class NoteDetail extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  static Task firstSleepTask = Task("Se lever à 7h30 du matin", true);
  static Task secondSleepTask = Task("Manger son petit déjeuner à 8h", false);
  static Task thirdSleepTask = Task("Se coucher avant minuit", false);

  static List<Task> sleepTasks = [
    firstSleepTask,
    secondSleepTask,
    thirdSleepTask
  ];

  Widget taskTile(BuildContext context, Task task, int index) {
    Widget taskCheckBox(BuildContext context, bool value) {
      return Checkbox(
        value: value,
        onChanged: (bool? value) {
          setState(
            () {
              sleepTasks[index].isChecked = value!;
            },
          );
        },
      );
    }

    return Container(
      height: 50,
      color: const Color(0xFF393939),
      child: Row(
        children: [
          taskCheckBox(context, task.isChecked),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8),
            child: Text(task.contentMessage,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de notes"),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.vertical,
          itemCount: sleepTasks.length,
          itemBuilder: (context, index) {
            final task = sleepTasks[index];

            return taskTile(context, task, index);
          },
        ),
      ),
    );
  }
}
