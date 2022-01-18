import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager extends ChangeNotifier {
  void saveUser(NoteUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodeData = jsonEncode(user.toJson());
    await prefs.setString('user', encodeData);
  }

  Future<NoteUser?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userString = prefs.getString('user');

    if (userString == null) {
      return null;
    } else {
      final NoteUser user = NoteUser.fromJson(jsonDecode(userString));
      notifyListeners();
      return user;
    }
  }

  void saveNotes(List<Note> notes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String encodeData = Note.encode(notes);
    await prefs.setString('favNotes', encodeData);
    notifyListeners();
  }

  void saveFavNote(Note note) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Note> prefsNotes = await getFavNotes();

    if (!prefsNotes.contains(note)) {
      prefsNotes.add(note);
      final String encodeData = Note.encode(prefsNotes);
      await prefs.setString('favNotes', encodeData);
    }
    notifyListeners();
  }

  Future<List<Note>> getFavNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? notesString = prefs.getString('favNotes');

    if (notesString == null) {
      return [];
    } else {
      final List<Note> notes = Note.decode(notesString);
      notifyListeners();
      return notes;
    }
  }

  void deleteFavNote(Note note) async {
    final List<Note> prefsnotes = await getFavNotes();

    prefsnotes.removeWhere((prefNote) => prefNote.id == note.id);
    saveNotes(prefsnotes);
    notifyListeners();
  }
}
