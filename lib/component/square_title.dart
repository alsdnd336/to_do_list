import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  const SquareTitle({required this.onTap ,required this.imagePath ,super.key});
  final String imagePath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200]
        ),
        child: Image.asset(imagePath, height: 40,),
      ),
    );
  }
}