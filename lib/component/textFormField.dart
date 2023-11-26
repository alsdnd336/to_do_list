import 'package:flutter/material.dart';

class MyTestFormField extends StatelessWidget {
  const MyTestFormField(
      {required this.obscureTextState,
      required this.controller,
      required this.hintText,
      required this.maxLength,
      super.key});
  final String hintText;
  final TextEditingController controller;
  final bool obscureTextState;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        obscureText: obscureTextState,
        decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        maxLength: maxLength,
      ),
    );
  }
}
