import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentProvider extends ChangeNotifier {
  
  List commentList = [];

  Future<void> importData(DocumentReference ref) async {
    // initalized 
    commentList = [];
    await ref.collection('comment').get().then((value) {
      value.docs.forEach((element) {
        commentList.add(element.data());
      });
    });
    commentList = commentList.reversed.toList();
    notifyListeners();
  }
  
}
