import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/component/likeButtonWidget.dart';
import 'package:to_do_list/main/contents_screen/comment_screen.dart';
import 'package:audioplayers/audioplayers.dart';

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
  late int likeNumber;
  late Map<String, dynamic> jsonData;

  // reference
  late DocumentReference postRef;

  Future<void> getContentsData() async {
    final data = await FirebaseFirestore.instance
        .collection('allPosts')
        .doc(widget.jsonData['postId'])
        .get();
    jsonData = data.data() as Map<String, dynamic>;

    // user posting like
    isLiked = jsonData['Likes'].contains(currentUser.uid);

    // allPosts reference
    postRef = FirebaseFirestore.instance
        .collection('allPosts')
        .doc(jsonData['postId']);
  }

  Text basicText(String text) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
  }

  @override
  build(BuildContext context) {
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
        child: FutureBuilder(
          future: getContentsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Container(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LikeButton(
                        isLiked: isLiked,
                        likeNumber: jsonData['Likes'].length,
                        ref: postRef,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                ref: postRef,
                              ))),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    jsonData['title'],
                    maxLines: 3,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  basicText(jsonData['information']),
                  const SizedBox(
                    height: 10,
                  ),
                  // slider widget
                  PlayBackSlide(
                    jsonData: jsonData,
                  )
                ],
              );
            } else {
              return Skeleton();
            }
          },
        ),
      ),
    );
  }
}

// loading widget
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(16))),
        ),
      ],
    );
  }
}

// audio file play button
class PlayBackSlide extends StatefulWidget {
  const PlayBackSlide({required this.jsonData, super.key});
  final Map<String, dynamic> jsonData;

  @override
  State<PlayBackSlide> createState() => _PlayBackSlideState();
}

class _PlayBackSlideState extends State<PlayBackSlide> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  bool isPlaying = true;
  // AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  AudioPlayer _audioPlayer = AudioPlayer();

  String formatTime(int seconds) {
    return '${Duration(seconds: seconds)}'.split('.')[0].padLeft(8, '0');
  }

  Text basicText(String text) {
    return Text(text,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
  }

  void getData() {
    _audioPlayer.play(UrlSource(widget.jsonData['audioFile']));
  }
  

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer.play(UrlSource(widget.jsonData['audioFile']));

    _audioPlayer.onDurationChanged.listen((Duration d) {
      duration = d;
    });

     _audioPlayer.onPositionChanged.listen((Duration p) {
      if(mounted) {
        setState(() {
          position = p;
        });
      }
      
    });
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
            await _audioPlayer.seek(position);
          },
          min: 0,
          max: duration.inSeconds.toDouble(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            basicText(formatTime(position.inSeconds)),
            basicText(formatTime(duration.inSeconds)),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        IconButton(
            onPressed: () async {
              if (isPlaying) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.resume();
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
    );
  }
}
