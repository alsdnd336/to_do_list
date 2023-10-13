import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.text,
    required this.onTap,
    super.key,
  });
  
  final String text;
  final Function() onTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent[700]!), // 원하는 배경색을 여기에 설정
        ),
        onPressed: onTap,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 25),),
      ),
    );

  }
}
