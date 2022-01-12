import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/note.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/screens/note_detail/note_detail.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';
import 'package:provider/provider.dart';
import 'add_note_dialog.dart';
import '../../data/models/models.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final DataRepository repository = DataRepository();
  final SharedPreferencesManager preferencesManager =
      SharedPreferencesManager();

  Widget noteTile(BuildContext context, Note note) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteDetail(noteId: note.id)));
      },
      child: Container(
          color: const Color(0xFF393939),
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 50,
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
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      setState(() {});
                      preferencesManager.saveFavNote(note);
                      final String message =
                          '${note.title} a été ajouté dans la liste de favoris';
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    },
                    icon: const Icon(Icons.add, color: Colors.grey)),
              )
            ],
          )),
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
    final note = Note.fromSnapshot(snapshot);
    return noteTile(context, note);
  }

  void _addNote() {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return const AddNoteDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: repository.getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data?.docs ?? []);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNote();
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
