
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{


  List contents = [1];

  void addElement(String text) {
    notifyListeners();
  }
}