import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/component/myShowSnackbar.dart';
import 'package:to_do_list/component/mybutton.dart';
import 'package:to_do_list/component/textFormField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/main/main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController checkController = TextEditingController();
  late String uid;

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void userInformation () async {
    FirebaseFirestore.instance.collection('userInformation').doc(uid).set({
      "id" : emailController.text,
      "name" : nameController.text,
      "uid" : uid,
      "password" : passwordController.text
    });
  }

  void singUpOnTap() async {
    if (emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        checkController.text.isNotEmpty) {
      if (passwordController.text == checkController.text) {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            });
        try {
          UserCredential _credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
          uid = FirebaseAuth.instance.currentUser!.uid;
          userInformation();
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        } on FirebaseAuthException catch (e) {
          if (e.code == "email-already-in-use") {
            MySnackBarMessage.showSnackBar(
                _scaffoldKey, '해당 이메일은 이미 존재하는 이메일 입니다.');
          } else if (e.code == "invalid-email") {
            MySnackBarMessage.showSnackBar(_scaffoldKey, '이메일 형식에 맞춰서 입력해주세요');
          } else if (e.code == "weak-password") {
            MySnackBarMessage.showSnackBar(_scaffoldKey, '해당 비밀번호는 취약합니다.');
          } else {
            MySnackBarMessage.showSnackBar(
                _scaffoldKey, '해당 이메일과 비밀번호는 입력할 수 없습니다.');
          }
          Navigator.pop(context);
          emailController.clear();
          passwordController.clear();
          checkController.clear();
        }
      } else {
        MySnackBarMessage.showSnackBar(_scaffoldKey, '입력하신 비밀번호가 일치하지 않습니다.');
        checkController.clear();
      }
    } else {
      MySnackBarMessage.showSnackBar(_scaffoldKey, '모든 칸에 정보를 입력해주세요');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blueAccent[100],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () => Navigator.pop(context),
            )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.blueAccent[100],
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_sharp,
                          color: Colors.white,
                          size: 80,
                        ),
                        Text('GLODEN TIME',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTestFormField(
                      obscureTextState: false,
                      controller: nameController,
                      hintText: '이름',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTestFormField(
                      obscureTextState: false,
                      controller: emailController,
                      hintText: '이메일',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTestFormField(
                      obscureTextState: true,
                      controller: passwordController,
                      hintText: '비밀번호',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTestFormField(
                      obscureTextState: true,
                      controller: checkController,
                      hintText: '비밀번호 확인',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyButton(text: '회원가입', onTap: singUpOnTap),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
