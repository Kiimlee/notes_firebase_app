import 'package:flutter/material.dart';

import 'note.dart';

class NotesManager extends ChangeNotifier {
  final _noteItems = <Note>[];
  int _selectedIndex = -1;
  bool _createNewItem = false;

  List<Note> get noteItems => List.unmodifiable(_noteItems);
  int get selectedIndex => _selectedIndex;
  Note? get selectedGroceryItem =>
      _selectedIndex != -1 ? _noteItems[_selectedIndex] : null;
  bool get isCreatingNewItem => _createNewItem;

  void createNewItem() {
    _createNewItem = true;
    notifyListeners();
  }

  void deleteItem(int index) {
    _noteItems.removeAt(index);
    notifyListeners();
  }

  void groceryItemTapped(int index) {
    _selectedIndex = index;
    _createNewItem = false;
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

  // void completeItem(int index, bool change) {
  //   final item = _noteItems[index];
  //   _noteItems[index] = item.copyWith(isComplete: change);
  //   notifyListeners();
  // }
}
