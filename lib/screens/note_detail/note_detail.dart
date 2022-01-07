import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/task.dart';
import 'add_task_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';

class NoteDetail extends StatefulWidget {
  const NoteDetail({Key? key, required this.noteId}) : super(key: key);

  final String noteId;

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final DataRepository repository = DataRepository();

  Widget taskCheckBox(BuildContext context, Task task) {
    return Checkbox(
      value: task.isChecked,
      onChanged: (bool? isChecked) {
        setState(
          () {
            task.isChecked = isChecked ?? false;
            final updatedTask =
                Task(task.contentMessage, task.isChecked, task.contentMessage);
            repository.updateTask(widget.noteId, task);
          },
        );
      },
    );
  }

  Widget taskTile(BuildContext context, Task task) {
    return Container(
      height: 50,
      color: const Color(0xFF393939),
      child: Row(
        children: [
          taskCheckBox(context, task),
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

  void _addTasks(String noteId) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AddTaskDialog(noteId: noteId);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      // 2
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final task = Task.fromSnapshot(snapshot);
    return taskTile(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de notes"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.getStreamDetail(widget.noteId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data?.docs ?? []);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTasks(widget.noteId);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
