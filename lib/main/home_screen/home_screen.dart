
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/component/posting_widget.dart';
import 'package:to_do_list/provider/home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider _homeProvider;

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
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return FutureBuilder(
      future: _homeProvider.importData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
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
                  (context, index) {
                    return PostingWidget(jsonData: Provider.of<HomeProvider>(context).userPosts[index]);
                  },
                  childCount: Provider.of<HomeProvider>(context).userPosts.length,
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
