import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/data/models/note.dart';
import 'package:notes_firebase_app/data/models/shared_preferences_manager.dart';
import 'package:notes_firebase_app/screens/note_detail/note_detail.dart';
import 'package:notes_firebase_app/repository/data_repository.dart';
import 'package:provider/provider.dart';
import '../../data/models/models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DataRepository repository = DataRepository();
  final SharedPreferencesManager preferencesManager =
      SharedPreferencesManager();
  List<Note> prefsNotes = [];

  Widget noteTile(BuildContext context, Note note) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoteDetail(noteId: note.id)));
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
      ),
      actions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.transparent,
            foregroundColor: Colors.black,
            iconWidget: const Icon(Icons.delete, color: Colors.red),
            onTap: () => deleteNote(note)),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'Delete',
            color: Colors.transparent,
            foregroundColor: Colors.black,
            iconWidget: const Icon(Icons.delete, color: Colors.red),
            onTap: () => deleteNote(note)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SharedPreferencesManager>(
          builder: (context, manager, child) {
        getPrefsNotes();
        return ListView.builder(
            padding: const EdgeInsets.only(top: 20.0),
            itemCount: prefsNotes.length,
            itemBuilder: (context, index) {
              return noteTile(context, prefsNotes[index]);
            });
      }),
    );
  }

  void getPrefsNotes() async {
    final notes = await preferencesManager.getFavNotes();
    prefsNotes = notes;
    setState(() {});
  }

  void deleteNote(Note note) async {
    if (note.id != null) {
      preferencesManager.deleteFavNote(note);
      setState(() {});
    } else {
      print('Recipe id is null');
    }
  }
}
