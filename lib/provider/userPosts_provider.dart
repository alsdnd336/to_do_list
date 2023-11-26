import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserPosts_Provider extends ChangeNotifier {

  List userPosts = [];

  Future<void> importData(String uid) async {
    // initalized 
    userPosts = [];
    await FirebaseFirestore.instance.collection('allPosts').get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['uid'] == uid) {
          userPosts.add(element.data());
        }
      });
    });
    userPosts = userPosts.reversed.toList();
    notifyListeners();
  }
}