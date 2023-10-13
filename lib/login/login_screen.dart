import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:to_do_list/component/myShowSnackbar.dart';
import 'package:to_do_list/component/mybutton.dart';
import 'package:to_do_list/component/square_title.dart';
import 'package:to_do_list/component/textFormField.dart';
import 'package:to_do_list/login/signup_screen.dart';
import 'package:to_do_list/main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late GoogleSignIn googleCurrnetUser;
  late String uid;


  void onTapLogin() async {
    showDialog(context: context, builder: (context){
      return Center(child: CircularProgressIndicator(color: Colors.blue));
    });
    if(emailController.text.isNotEmpty || passwordController.text.isNotEmpty){
      try {
        UserCredential _credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
        Navigator.pushReplacementNamed(context, MainScreen.routeName);
      } on FirebaseAuthException catch(e) {
        MySnackBarMessage.showSnackBar(_scaffoldKey, '아이디 혹은 비밀번호가 잘못됐습니다.');
        passwordController.clear();
        Navigator.pop(context);
      }
      
    }
  }

  Future<void> googleLogin() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _account = await _googleSignIn.signIn();
    if (_account != null) {
      GoogleSignInAuthentication _authentication =
          await _account.authentication;
      OAuthCredential _googleCredential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken,
      );
      UserCredential _credential =
        await FirebaseAuth.instance.signInWithCredential(_googleCredential);
      
      SocialLoginDataCheck();
    }

  }

  void appleLogin() {

  }

  void SocialLoginDataCheck() async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('userInformation').doc(uid).get();
    if(document.exists) {
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    } else {
      // social login user information
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.blueAccent[100],
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_sharp, color: Colors.white, size: 80,),
                    Text('GLODEN TIME', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20,),
                MyTestFormField(
                  obscureTextState: false,
                  controller: emailController,
                  hintText: '이메일',
                ),
                const SizedBox(height: 10,),
                MyTestFormField(
                  obscureTextState: true,
                  controller: passwordController,
                  hintText: '비밀번호',
                ),
                const SizedBox(height: 25,),
                MyButton(text: '로그인', onTap: onTapLogin),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTitle(imagePath: 'images/google.png', onTap: googleLogin),
                    const SizedBox(width: 25,),
                    SquareTitle(imagePath: 'images/apple.png', onTap: appleLogin,),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(color: Colors.white, thickness: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){}, child: Text('비밀번호 찾기', style: TextStyle(color: Colors.white, fontSize: 17),)),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return SignUpScreen();
                      }));
                    }, child: Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 17),))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


