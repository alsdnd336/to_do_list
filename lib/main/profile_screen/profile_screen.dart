import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/component/posting_widget.dart';
import 'package:to_do_list/provider/userPosts_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserPosts_Provider _userPosts_Provider;
  late List<Widget> contentsList;

  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool serverData = false;

  // Displaying User Information
  Widget profileWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            radius: MediaQuery.of(context).size.width / 7,
          ),
          const SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User information', style: const TextStyle(fontSize: 15),),
            ],
          ),
        ],
      ),
    );
  }

  void contentsWidget() {
    if(Provider.of<UserPosts_Provider>(context).userPosts.length != 0){
      List.generate(Provider.of<UserPosts_Provider>(context).userPosts.length, (index) {
        contentsList.add(PostingWidget(jsonData: Provider.of<UserPosts_Provider>(context).userPosts[index]));
      }); 
    }else {
      contentsList.add(Center(child: Text('게시물이 없습니다'),));
    }
    // return const Center(child: Text('게시물이 없습니다'),);
  }

  @override
  void didChangeDependencies() {
    _userPosts_Provider = Provider.of<UserPosts_Provider>(context, listen: false);
    _userPosts_Provider.importData(uid);
    contentsWidget();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: MediaQuery.of(context).size.height,
    //   child: Column(
    //     children: [
    //       Container(
    //         width: double.infinity,
    //         height: 50,
    //         color: Colors.blueAccent[100],
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text('User Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
    //             IconButton(
    //               onPressed: (){
    //                 setState(() {});
    //               },
    //               icon: const Icon(Icons.settings, color: Colors.white, size: 30,),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   )
    // );
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: false,
          backgroundColor: Colors.blueAccent[100],
          title: const Text('User Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
          actions: [
            IconButton(
              onPressed: (){
                setState(() {});
              },
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
        SliverToBoxAdapter(
          child: Column(
            children: contentsList,
          )
        ),
        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
          
        //         (context, index) {
        //       if(index < Provider.of<UserPosts_Provider>(context).userPosts.length){
        //         return PostingWidget(jsonData: Provider.of<UserPosts_Provider>(context).userPosts[index]);
        //       }
        //     },
        //     childCount: Provider.of<UserPosts_Provider>(context).userPosts.length,

        //   ),
        // )
      ],
    );
  }
}