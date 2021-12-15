import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase_app/screens/notes_list/notes_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//2
  await Firebase.initializeApp();
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
