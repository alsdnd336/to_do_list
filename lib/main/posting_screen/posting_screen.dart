import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:to_do_list/component/filedragWidget.dart';
import 'package:to_do_list/component/myShowSnackbar.dart';
import 'package:to_do_list/main/posting_screen/details_screen.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});
  static const routeName = '/postingScreen';

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  FilePickerResult? result;
  PlatformFile? pickedfile;

  // audio pick upload
  void pickAudioFile() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result!.files.first.name.contains('.mp3')) {
        pickedfile = result!.files.first;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return DetailsScreen(audioFile: pickedfile!.path.toString(),);
        }));
      } else {
        ScaffoldMessenger.of(context) 
          .showSnackBar(const SnackBar(content: Text('mp3 파일만 업로드 가능합니다.')));
      }
    } catch (e) {
      print("File picking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Selectafile_widget(
            fileText: '음성 파일 업로드하기',
            // onTap: () {
              onTap: pickAudioFile,
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return DetailsScreen(radioFile: 'assets/music.mp3',);
            //   }));
            // },
          )),
    );
  }
}
