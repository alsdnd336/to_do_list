import 'package:flutter/material.dart';

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({required this.jsonData, super.key});
  final Map<String, dynamic> jsonData;


  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}