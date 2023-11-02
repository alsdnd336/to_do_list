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
                backgroundColor: Colors.grey,
                radius: 20,
              ),
              const SizedBox(width: 10,),
              Text(jsonData['title']),
            ],
          ),
        ],
      ),
    );
  }
}