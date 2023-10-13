import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:to_do_list/main/Calendar/calendar.dart';
import 'package:to_do_list/main/Timebox/Timebox_screen.dart';
import 'package:to_do_list/main/phone_lock/phone_lock_screen.dart';
import 'package:to_do_list/main/setting/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  
  static const routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List Screens = [
    CalendarScreen(),

    TimeboxScreen(),
    PhoneLockScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : SafeArea(
        child: Screens[_selectedIndex],
      ), 
      bottomNavigationBar: Container(
        color: Colors.blueAccent[700],
        padding: EdgeInsets.symmetric(vertical: 10),
        child: GNav(
          backgroundColor: Colors.blueAccent[700]!,
          color: Colors.white,
          activeColor: Colors.white,
          iconSize: 25,
          tabs: [
            GButton(icon: Icons.calendar_month, text: 'Calendar',),
            GButton(icon: Icons.timelapse_sharp, text: 'TimeBox',),
            GButton(icon: Icons.lock_clock_rounded, text: 'Phone lock',),
            GButton(icon: Icons.settings, text: 'Setting',),
          ],
          selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
        ),
      ),
    );
  }
}