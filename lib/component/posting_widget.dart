import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class PostingWidget extends StatelessWidget {
  const PostingWidget({required this.jsonData ,super.key});
  final Map<String, dynamic> jsonData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(jsonData['thumbnail']), fit: BoxFit.cover, ),
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: jsonData['userProfile'] == '' ? const AssetImage('images/profile_basic_image.png') : FileImage(File(jsonData['userProfile'])) as ImageProvider ,
                backgroundColor: Colors.grey,
                radius: 20,
              ),
              const SizedBox(width: 10,),
              Column(
                children: [
                  Text(jsonData['title'], style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                  Text(jsonData['userName'], style: const TextStyle(color: Colors.grey, fontSize: 13),)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}