import 'package:flutter/material.dart';

class Selectafile_widget extends StatelessWidget {
  const Selectafile_widget({
    required this.fileText,
    required this.onTap,
    super.key,
  });

  final String fileText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Text(fileText, style: const TextStyle(color: Colors.grey, fontSize: 25,)),
      ),
    );
  }
}