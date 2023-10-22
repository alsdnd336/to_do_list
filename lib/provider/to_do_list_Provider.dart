import 'package:flutter/material.dart';

class ToDoListProvider extends ChangeNotifier{
  List<String> contentsList = ['checkField'];

  void addElement(String text) {
    contentsList.add(text);
    notifyListeners();
  }

}