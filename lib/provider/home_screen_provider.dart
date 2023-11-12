
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{

  List userPosts = [];

  Future<void> importData() async {
    // initalized 
    userPosts = [];
    await FirebaseFirestore.instance.collection('allPosts').get().then((value) {
      value.docs.forEach((element) {
        userPosts.add(element.data());
      });
    });
    
    notifyListeners();
  }
}