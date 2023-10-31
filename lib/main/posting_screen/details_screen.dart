import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/component/SelectImage.dart';
import 'package:to_do_list/component/filedragWidget.dart';
import 'package:to_do_list/component/mySnackbar.dart';
import 'package:to_do_list/component/mybutton.dart';
import 'package:to_do_list/component/textFormField.dart';
import 'package:pluto_menu_bar/pluto_menu_bar.dart';
import 'package:to_do_list/provider/main_screen_provider.dart';
import 'package:to_do_list/provider/thumbnail_image_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({required this.radioFile ,super.key});

  final String radioFile;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _informationContrller = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  FirebaseAuth instance = FirebaseAuth.instance;

  //fire base
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _currentTopic = 'IT·컴퓨터';

  // thumbnail provider
  late thumbnailImageProvider _thumbnailImageProvider;
  late Main_screen_provider _main_screen_provider;

  // send data to the server
  void sendDataServer() async {
    if (_titleController.text.isNotEmpty &&
        _informationContrller.text.isNotEmpty &&
        _thumbnailImageProvider.thumbnailPath != null) {
      await _firestore
          .collection("userPosting")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(_titleController.text)
          .doc(_titleController.text)
          .set({
        "title": _titleController.text,
        "information": _informationContrller.text,
        "topic": _currentTopic,
        "thumbnail": _thumbnailImageProvider.thumbnailPath,
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now(),
        "radioFile" : widget.radioFile,
      });
      Navigator.popUntil(context, ModalRoute.withName('/main'));
      MyMessage.showSnackBar(_scaffoldKey, '해당 글을 올렸습니다.');
      // go back first page
      _main_screen_provider.setCurrentIndex(0);
    } else {
      MyMessage.showSnackBar(_scaffoldKey, '빈칸을 모두 채워주세요');
    }
  }

  // image picker
  Future<void> _pickCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      _thumbnailImageProvider.setThumbnailPath(image.path);
      Navigator.pop(context);
    }
  }

  Future<void> _pickGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _thumbnailImageProvider.setThumbnailPath(image.path);
      Navigator.pop(context);
    }
  }

  Widget topicItem(String text) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }

  Widget topicBarWidget() {
    return PlutoMenuBar(
      mode: PlutoMenuBarMode.tap,

      itemStyle: const PlutoMenuItemStyle(
        enableSelectedTopMenu: true,

      ),
      
      menus: [
        PlutoMenuItem(
          title: 'IT·컴퓨터',
          id: 'IT·컴퓨터',
          onTap: () => CurrentTopic('IT·컴퓨터'),
        ),
        PlutoMenuItem(
          title: '사회·정치',
          id: '사회·정치',
          onTap: () => CurrentTopic('사회·정치'),
        ),
        PlutoMenuItem(
          title: '건강·의학',
          id: '건강·의학',
          onTap: () => CurrentTopic('건강·의학'),
        ),
        PlutoMenuItem(
          title: '비즈니스·경제',
          id: '비즈니스·경제',
          onTap: () => CurrentTopic('비즈니스·경제'),
        ),
        PlutoMenuItem(
          title: '어학·외국어',
          id: '어학·외국어',
          onTap: () => CurrentTopic('어학·외국어'),
        ),
        PlutoMenuItem(
          title: '교육·학문',
          id: '교육·학문',
          onTap: () => CurrentTopic('교육·학문'),
        ),
      ],
    );
  }

  void CurrentTopic(String topic) {
    _currentTopic = topic;
    
  }

  @override
  void dispose() {

    // return initialization
    _titleController.dispose();
    _informationContrller.dispose();
    _currentTopic = 'IT·컴퓨터';
    _thumbnailImageProvider.thumbnailPath = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('hello');
    _thumbnailImageProvider =
        Provider.of<thumbnailImageProvider>(context, listen: false);
    _main_screen_provider = Provider.of<Main_screen_provider>(context, listen: false);
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: const Text('해당 페이지 나가면 작성하신 내용이 사라집니다.', style: TextStyle(fontSize: 18),),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.popUntil(context, ModalRoute.withName('/main'));
                        
                      }, child: const Text('나가기', style: TextStyle(color: Colors.red),), ),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text('머무르기', style: TextStyle(color: Colors.blue),), ),
                    ],
                  );
                });
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: Colors.blueAccent[100],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.blueAccent[100],
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                MyTestFormField(
                    controller: _titleController,
                    hintText: '제목을 입력하시오',
                    obscureTextState: false),
                const SizedBox(
                  height: 20,
                ),
                Consumer(
                  builder: (context, value, child) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Provider.of<thumbnailImageProvider>(context)
                                    .thumbnailPath !=
                                null
                            ? Image.file(File(
                                Provider.of<thumbnailImageProvider>(context)
                                    .thumbnailPath!))
                            : Selectafile_widget(
                                fileText: '썸네일을 선택하시오',
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SelectImage(
                                          camera: _pickCamera,
                                          gallery: _pickGallery,
                                        );
                                      });
                                },
                              ));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTestFormField(
                    controller: _informationContrller,
                    hintText: '소개글을 입력하시오',
                    obscureTextState: false),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '주제 선택',
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      topicBarWidget()

                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(text: '완료', onTap: sendDataServer)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
