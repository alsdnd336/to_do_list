import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/component/likeButtonWidget.dart';
import 'package:to_do_list/component/timeWidget.dart';
import 'package:to_do_list/provider/comment_provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({required this.ref ,super.key});
  final DocumentReference ref;


  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  TextEditingController _sendTextEditingController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late CommentProvider _commentProvider;

  // userInformation
  String? userName;
  late String userProfile;

  void sendMessage() async {
    int docNumber = await widget.ref.collection('comment').count().get().then((value) {
      return value.count;
    });
    
    if (_sendTextEditingController.text.isNotEmpty && userName != null) {
      widget.ref.collection('comment').doc(docNumber.toString()).set({
        'uid' : uid,
        'userName' : userName,
        'comment' : _sendTextEditingController.text,
        'time' : DateTime.now(),
        'userProfile' : userProfile,
        'Likes' : [],
        'commentId' : docNumber.toString(),
      });
      _sendTextEditingController.clear();
      setState(() {});
    }
    
  }

  Widget commentWidget(Map<String, dynamic> jsonData) {

    bool isLiked = jsonData['Likes'].contains(uid);
    int likeNumber = jsonData['Likes'].length;
    DocumentReference _commentRef = widget.ref.collection('comment').doc(jsonData['commentId']);

    return ListTile( 
      leading: CircleAvatar(
        backgroundImage: jsonData['userProfile'] == '' ? const AssetImage('images/profile_basic_image.png') : NetworkImage(jsonData['userProfile']) as ImageProvider,
      ),
      title: Row(
        children: [
          Expanded(child: Text(jsonData['userName'], overflow: TextOverflow.ellipsis,)),
          const SizedBox(width: 10,),
          TimeWidget(contentsTime: jsonData['time'],),
        ],
      ),
      subtitle: Text(jsonData['comment']),
      trailing: LikeButton(
        color: Colors.black,
        isLiked: isLiked,
        likeNumber: likeNumber,
        ref: _commentRef,
      ),
      
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('userInformation').doc(uid).get().then((value) {
      userName = value.data()!['name'];
      userProfile = value.data()!['userProfile'];
    });
  }

  @override
  Widget build(BuildContext context) {
    _commentProvider = Provider.of<CommentProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text(
          '게시물 댓글',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _commentProvider.importData(widget.ref),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: Provider.of<CommentProvider>(context).commentList.length,
                      itemBuilder: (context, index) {

                        return commentWidget(Provider.of<CommentProvider>(context).commentList[index]); 
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const Skeleton();
                      },
                    );
                  }
                }
              ),

            ),
            SendBar(controller: _sendTextEditingController, onTap: sendMessage,),
          ],
        ),
      ),
    );
  }
}

class SendBar extends StatelessWidget {
  const SendBar({
    required this.controller,
    required this.onTap,
    super.key,
  });

  final TextEditingController controller;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(color: Colors.grey),
          )
      ),
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: null,
              controller: controller,
              decoration: const InputDecoration(
                hintText: '내용을 입력해주세요',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),

              ),
            ),
          ),
        IconButton(onPressed: onTap, icon: const Icon(Icons.send_rounded, color: Colors.blue,))
        ],
      ),
    );
  }
}


class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.04),
      ),
      trailing: Icon(Icons.favorite, color: Colors.black.withOpacity(0.04),),
      title: Container(
        height: 10,
        width: double.infinity,
        color: Colors.black.withOpacity(0.04),
      ),
      subtitle: Container(
        height: 10,
        width: double.infinity,
        color: Colors.black.withOpacity(0.04),
      ),
    );
  }
}