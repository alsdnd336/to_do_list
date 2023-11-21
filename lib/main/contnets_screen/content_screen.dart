import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ContentsScreen extends StatefulWidget{
  const ContentsScreen({required this.jsonData, super.key});
  final Map<String, dynamic> jsonData;

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {

  //user firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  late bool isLiked;
  late int likeNumber;
   Map<String, dynamic>? jsonData;

  AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // reference 
  late DocumentReference postRef;


  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  Text basicText(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }


 
  Future<void> getContentsData() async {
    final data = await FirebaseFirestore.instance.collection('allPosts').doc(widget.jsonData['postId']).get();
    jsonData = data.data() as Map<String, dynamic>;

    _assetsAudioPlayer.open(
      Audio(jsonData!['radioFile']),
      loopMode: LoopMode.single, //반복 여부 (LoopMode.none : 없음)
      autoStart: false, //자동 시작 여부
      showNotification: false, //스마트폰 알림 창에 띄울지 여부
    );

    _assetsAudioPlayer.current.listen((playingAudio) {
      duration = playingAudio!.audio.duration;
    });

    _assetsAudioPlayer.currentPosition.listen((currentPosition) {
      setState(() {
        position = currentPosition;      
      });
    });

    // user posting like
    isLiked = jsonData!['Likes'].contains(currentUser.email);

    // allPosts reference
    postRef = FirebaseFirestore.instance
        .collection('allPosts')
        .doc(jsonData!['postId']);
    
    setState(() {});
  }

  @override
  void initState() {
    getContentsData();
    super.initState();
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    if(jsonData != null) {
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
                    jsonData!['thumbnail'],
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
                  LikeButton(
                    isLiked: isLiked,
                    ref: postRef,
                    likeNumber: jsonData!['Likes'].length,
                  ),
                  Text(
                    jsonData!['title'],
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
              basicText(jsonData!['information']),
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
          )),
    );

    } else {
      return Container();
    }
        
  }
}

class LikeButton extends StatefulWidget{
  bool isLiked;
  final DocumentReference ref;
  final int likeNumber;
  LikeButton({required this.isLiked, required this.ref, required this.likeNumber, super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late int likeNumber;

  @override
  void initState() {
    likeNumber = widget.likeNumber;  
    super.initState();
  }

  final currentUser = FirebaseAuth.instance.currentUser!;

  void toggleLike() {
    setState(() {
      if(widget.isLiked) {
        likeNumber--;
      } else {
        likeNumber++;
      }
      widget.isLiked = !widget.isLiked;
    });
    
    // Adding data to a post   
    if(widget.isLiked) {
      
      widget.ref.update({
        'Likes' : FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      widget.ref.update({
        'Likes' : FieldValue.arrayRemove([currentUser.email])
      });
    }
  }


  @override
  build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleLike,
          child: Icon(
            widget.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.isLiked ? Colors.red : Colors.white,
          ),
        ),
        const SizedBox(
          height: 5,),
        Text(likeNumber.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ],
    );
  }
}

class PlayBackSlide extends StatefulWidget {
  const PlayBackSlide({required this.assetsAudioPlayer ,super.key});
  final AssetsAudioPlayer assetsAudioPlayer;

  @override
  State<PlayBackSlide> createState() => _PlayBackSlideState();
}

class _PlayBackSlideState extends State<PlayBackSlide> {
  // AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  Text basicText(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }



  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          value: position.inSeconds.toDouble(),
          onChanged: (double value) async {
            final position = Duration(seconds: value.toInt());
            await widget.assetsAudioPlayer.seek(position);
          },
          min: 0,
          max: duration.inSeconds.toDouble(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(formatTime(position.inSeconds)),
            PlayerBuilder.currentPosition(
                player: widget.assetsAudioPlayer,
                builder: (context, duration) {
                  position = duration;
                  return basicText(formatTime(position.inSeconds));
                }),
            basicText(formatTime((duration - position).inSeconds)),
          ],
        ),
      ],
    );
  }
}