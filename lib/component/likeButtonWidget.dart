import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  bool isLiked;
  final int likeNumber;
  final DocumentReference ref;
  final Color color;
  LikeButton(
      {required this.isLiked,
      required this.likeNumber,
      required this.ref,
      required this.color,
      super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int likeNumber;
  final uid = FirebaseAuth.instance.currentUser!.uid;

    void toggleLike() {
    setState(() {
      if (widget.isLiked) {
        likeNumber--;
      } else {
        likeNumber++;
      }
      widget.isLiked = !widget.isLiked;
    });

    // Adding data to a post
    if (widget.isLiked) {
      widget.ref.update({
        'Likes': FieldValue.arrayUnion([uid])
      });
    } else {
      widget.ref.update({
        'Likes': FieldValue.arrayRemove([uid])
      });
    }
  }


  @override
  void initState() {
    likeNumber = widget.likeNumber;
    super.initState();
  }  

  @override
  build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleLike,
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.red : widget.color,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          likeNumber.toString(),
          style: TextStyle(color: widget.color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}