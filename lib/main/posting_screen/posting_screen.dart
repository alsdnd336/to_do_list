import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:to_do_list/component/filedragWidget.dart';
import 'package:to_do_list/main/posting_screen/details_screen.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});
  static const routeName = '/postingScreen';

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  FilePickerResult? result;
  PlatformFile? pickedfile;
  String? _fileNamed;
  File? fileToDisplay;

  // audio pick upload
  void pickAudioFile() async {
    String? filePath;
    try {
      result = await FilePicker.platform.pickFiles(
        // file type designation
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        _fileNamed = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
      }
    } catch (e) {
      print("File picking error: $e");
    }

    print('fileNmae : $_fileNamed');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Selectafile_widget(
          fileText: '음성 파일 업로드하기',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailsScreen(radioFile: 'assets/music.mp3',);
            }));
          },
        ));
  }
}
