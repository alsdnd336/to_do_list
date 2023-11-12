import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_list/component/SelectImage.dart';
import 'package:to_do_list/component/myShowSnackbar.dart';
import 'package:to_do_list/component/mybutton.dart';
import 'package:to_do_list/component/textFormField.dart';


class ProfileAdjustment extends StatefulWidget {
  const ProfileAdjustment(
      {required this.userProfile,
      required this.userName,
      required this.userInformation,
      super.key});

  final String userProfile;
  final String userName;
  final String userInformation;

  @override
  State<ProfileAdjustment> createState() => _ProfileAdjustmentState();
}

class _ProfileAdjustmentState extends State<ProfileAdjustment> {
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userInformationController =
      TextEditingController();
  
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late String userProfile;

  // change 
  void DataUpdate() async {
    if (userNameController.text == widget.userName &&
        userInformationController.text == widget.userInformation &&
        userProfile == widget.userProfile) {
        MySnackBarMessage.showSnackBar(_scaffoldKey, '변경사항이 없습니다.');
    } else {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('userInformation').doc(uid);
      // update data
      Map<String, dynamic> dataToUpdate = {
        'name' : userNameController.text,
        'userInformation' : userInformationController.text,
        'userProfile' : userProfile,
      };

      try {
        await userDocRef.update(dataToUpdate);
        // Navigator.popUntil(context, ModalRoute.withName('/main'));
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } catch (e) {
        print('문서 업데이트 실패: $e');
      }
    }

  }

  Future<void> _pickCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        userProfile = image.path;
      });
      Navigator.pop(context); 
    }
  }

  Future<void> _pickGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userProfile = image.path;
      });
      Navigator.pop(context);
    }
  }

  // image change 
  void imageChange() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SelectImage(
          camera: _pickCamera,
          gallery: _pickGallery,
        );
      }
    );
  }

  @override
  void initState() {
    userNameController.text = widget.userName;
    userInformationController.text = widget.userInformation;
    userProfile = widget.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent[100],
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.blueAccent[100],
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: userProfile == ''
                      ? const AssetImage('images/profile_basic_image.png')
                      : FileImage(File(userProfile)) as ImageProvider,
                  backgroundColor: Colors.grey,
                  radius: MediaQuery.of(context).size.width / 5,
                ),
                TextButton(
                  onPressed: imageChange,
                  child: const Text(
                    '프로필 사진 변경',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTestFormField(
                  controller: userNameController,
                  hintText: '이름을 입력해주세요',
                  obscureTextState: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTestFormField(
                  controller: userInformationController,
                  hintText: '소개글을 입력해주세요',
                  obscureTextState: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(text: '변경', onTap: DataUpdate)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
