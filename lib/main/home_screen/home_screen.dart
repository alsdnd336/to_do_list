
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/provider/home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Widget makeSearchBar() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueAccent[100]
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Golden Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.search, color: Colors.white, size: 30,),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          centerTitle: false,
          backgroundColor: Colors.blueAccent[100],
          title: const Text('Golden Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
          actions: [
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search, color: Colors.white, size: 30,),
            )
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Center(child: Text('hello'),);
            },
            childCount: Provider.of<HomeProvider>(context).contents.length,
          ),
        ),
      ],
    );
  }
}