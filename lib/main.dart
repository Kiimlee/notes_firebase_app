import 'package:flutter/material.dart';
import 'package:notes_firebase_app/screens/notes_list/notes_list.dart';

void main() {
  runApp(const NoteFirebaseApp());
}

class NoteFirebaseApp extends StatelessWidget {
  const NoteFirebaseApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesList(title: 'My notes'),
    );
  }
}
