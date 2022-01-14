import 'package:flutter/material.dart';

import 'note.dart';

class NotesManager extends ChangeNotifier {
  final _noteItems = <Note>[];
  int _selectedIndex = -1;
  bool _createNewItem = false;

  List<Note> get noteItems => List.unmodifiable(_noteItems);
  int get selectedIndex => _selectedIndex;
  bool get isCreatingNewItem => _createNewItem;

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void deleteItem(int index) {
    _noteItems.removeAt(index);
    notifyListeners();
  }

  void addItem(Note item) {
    _noteItems.add(item);
    _createNewItem = false;
    notifyListeners();
  }

  void updateItem(Note item, int index) {
    _noteItems[index] = item;
    _selectedIndex = -1;
    _createNewItem = false;
    notifyListeners();
  }
}
