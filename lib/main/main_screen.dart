import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/main/home_screen/home_screen.dart';
import 'package:to_do_list/main/posting_screen/posting_screen.dart';
import 'package:to_do_list/main/profile_screen/profile_screen.dart';
import 'package:to_do_list/provider/main_screen_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  
  static const routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  late Main_screen_provider _main_screen_provider;

  final List Screens = const [
    HomeScreen(),
    PostingScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    _main_screen_provider = Provider.of<Main_screen_provider>(context, listen: false);
    return Scaffold(
      body : Screens[Provider.of<Main_screen_provider>(context).currentIndex], 
      bottomNavigationBar: GNav(
          backgroundColor: Colors.blueAccent[100]!,
          color: Colors.white,
          activeColor: Colors.blueAccent[700],
          iconSize: 25,          
          tabs: const [
            GButton(icon: Icons.home,),
            GButton(icon: Icons.add),
            GButton(icon: Icons.person),
          ],
          selectedIndex: Provider.of<Main_screen_provider>(context).currentIndex,
            onTabChange: (index) {
              _main_screen_provider.setCurrentIndex(index);
            },
        ),
    );
  }
}