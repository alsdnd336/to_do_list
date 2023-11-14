import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({required this.jsonData, super.key});
  final Map<String, dynamic> jsonData;

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  //user firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;

  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // reference 
  late DocumentReference postRef;
  late DocumentReference userPostingRef;


  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  Text basicText(String text) {
    return Text(text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    
    // Adding data to a post   
    if(isLiked) {
      postRef.update({
        'Likes' : FieldValue.arrayUnion([currentUser.email])
      });
      userPostingRef.update({
        'Likes' : FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes' : FieldValue.arrayRemove([currentUser.email])
      });
      userPostingRef.update({
        'Likes' : FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer.open(
      Audio(widget.jsonData['radioFile']),
      loopMode: LoopMode.single, //반복 여부 (LoopMode.none : 없음)
      autoStart: false, //자동 시작 여부
      showNotification: false, //스마트폰 알림 창에 띄울지 여부
    );

    print(widget.jsonData['postId']);
    _assetsAudioPlayer.current.listen((playingAudio) {
      duration = playingAudio!.audio.duration;
    });

    _assetsAudioPlayer.currentPosition.listen((currentPosition) {
      setState(() {
        position = currentPosition;
      });
    });

    // user posting like
    isLiked = widget.jsonData['Likes'].contains(currentUser.email);
    print(isLiked);

    // allPosts reference
    postRef = FirebaseFirestore.instance
        .collection('allPosts')
        .doc(widget.jsonData['postId']);

    // userPosting reference
    userPostingRef = FirebaseFirestore.instance
        .collection('userPosting')
        .doc('userPosting')
        .collection(widget.jsonData['uid'])
        .doc(widget.jsonData['title']);
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent[100],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
            color: Colors.blueAccent[100],
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.jsonData['thumbnail'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        LikeButton(
                          isLiked: isLiked,
                          onTap: toggleLike,
                        ),
                        const SizedBox(
                          height: 5,),
                        basicText(widget.jsonData['Likes'].length.toString()),
                      ],
                    ),
                    Text(
                      widget.jsonData['title'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ))
                  ],
                ),
                basicText(widget.jsonData['information']),
                const SizedBox(
                  height: 10,
                ),
                Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: position.inSeconds.toDouble(),
                  onChanged: (double value) async {
                    final position = Duration(seconds: value.toInt());
                    await _assetsAudioPlayer.seek(position);
                  },
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(formatTime(position.inSeconds)),
                    PlayerBuilder.currentPosition(
                        player: _assetsAudioPlayer,
                        builder: (context, duration) {
                          position = duration;
                          return basicText(formatTime(position.inSeconds));
                        }),
                    basicText(formatTime((duration - position).inSeconds)),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                IconButton(
                    onPressed: () async {
                      if (isPlaying) {
                        _assetsAudioPlayer.pause();
                      } else {
                        _assetsAudioPlayer.play();
                      }
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                    icon: isPlaying == false
                        ? Icon(
                            Icons.play_circle,
                            color: Colors.white,
                            size: 60,
                          )
                        : Icon(
                            Icons.pause_circle_filled_sharp,
                            color: Colors.white,
                            size: 60,
                          )),
              ],
            )));
  }
}

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final Function()? onTap;
  const LikeButton({required this.isLiked, required this.onTap, super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Icon(
        widget.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.isLiked ? Colors.red : Colors.white,
      ),
    );
  }
}
