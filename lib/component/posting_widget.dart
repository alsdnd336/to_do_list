import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/component/timeWidget.dart';
import 'package:to_do_list/main/contents_screen/content_screen.dart';

class PostingWidget extends StatelessWidget {
  const PostingWidget({required this.jsonData, super.key});
  final Map<String, dynamic> jsonData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContentsScreen(
                            jsonData: jsonData,
                          )));
            },
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  jsonData['thumbnail'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: jsonData['userProfile'] == ''
                    ? const AssetImage('images/profile_basic_image.png')
                    : NetworkImage(jsonData['userProfile']) as ImageProvider,
                backgroundColor: Colors.grey,
                radius: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jsonData['title'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      jsonData['userName'],
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
              ),
              TimeWidget(contentsTime: jsonData['time'],)
            ],
          ),
        ],
      ),
    );
  }
}
