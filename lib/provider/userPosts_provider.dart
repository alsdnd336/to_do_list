import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserPosts_Provider extends ChangeNotifier {

  List userPosts = [];

  Future<void> importData(String uid) async {
    // initalized 
    userPosts = [];
    await FirebaseFirestore.instance.collection('userPosting').doc('userPosting').collection(uid).get().then((value) {
      value.docs.forEach((element) {
        userPosts.add(element.data());
      });
    });
    
    notifyListeners();
  }
}