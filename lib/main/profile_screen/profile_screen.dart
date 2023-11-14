import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/component/posting_widget.dart';
import 'package:to_do_list/main/profile_screen/profile_adjustment.dart';
import 'package:to_do_list/provider/home_screen_provider.dart';
import 'package:to_do_list/provider/main_screen_provider.dart';
import 'package:to_do_list/provider/userPosts_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserPosts_Provider _userPosts_Provider;
  late Main_screen_provider _main_screen_provider;

  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool serverData = false;
  List userPosts = [];

  late String userName;
  late String userProfile;
  late String userInformation;
  late String userImagePath;

  // Displaying User Information
  Widget profileWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: userProfile == '' ? const AssetImage('images/profile_basic_image.png') : NetworkImage(userProfile) as ImageProvider ,
            backgroundColor: Colors.grey,
            radius: MediaQuery.of(context).size.width / 7,
          ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userInformation == '' ? '소개글이 없습니다.' : userInformation , style: const TextStyle(fontSize: 15),),
            ],
          ),
        ],
      ),
    );
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    _main_screen_provider.setCurrentIndex(0);
  }

  void settingDialog() {
    showDialog(
      context: context,
      builder: (context){
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height / 5,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                settingItem(const Text('프로필 수정', style: TextStyle(fontSize: 20),) , () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ProfileAdjustment(userProfile: userImagePath, userName: userName, userInformation: userInformation,);
                  }));
                }),
                settingItem(const Text('로그아웃', style: TextStyle(fontSize: 20, color: Colors.red)), logOut)
              ],
            ),
          ),
        );
      }
    );
  }

  Widget settingItem(Text contents, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: contents,
        ),
      )
    );
  }


  @override
  void initState() {
    // get a user Information
    FirebaseFirestore.instance.collection('userInformation').doc(uid).get().then((value) {
      final jsonData = value.data() as Map<String, dynamic>;
      userName = jsonData['name'];
      userProfile = jsonData['userProfile'];
      userInformation = jsonData['userInformation'];
      userImagePath = jsonData['imagePath'];
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userPosts_Provider = Provider.of<UserPosts_Provider>(context, listen: false);
    _main_screen_provider = Provider.of<Main_screen_provider>(context, listen: false);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userPosts_Provider.importData(uid),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: false,
                backgroundColor: Colors.blueAccent[100],
                title: Text(userName , style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                actions: [
                  IconButton(
                    onPressed: settingDialog,
                    icon: const Icon(Icons.settings, color: Colors.white, size: 30,),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: profileWidget(),
              ),
              const SliverToBoxAdapter(
                child:  Divider(thickness: 1, color: Colors.grey,),
              ),
              if(Provider.of<UserPosts_Provider>(context).userPosts.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Text('게시물이 없습니다.', style: TextStyle(fontSize: 20, color: Colors.black54),),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return PostingWidget(jsonData: Provider.of<UserPosts_Provider>(context).userPosts[index]);
                  },
                  childCount: Provider.of<UserPosts_Provider>(context).userPosts.length,
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },

    );
  }
}
