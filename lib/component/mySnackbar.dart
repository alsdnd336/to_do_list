import 'package:flutter/material.dart';

class MyMessage {
  static void showSnackBar (var _scaffoldKey, String message){
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.white,
            content: Text(
      message ,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.black),
    ))
    );
  }
}