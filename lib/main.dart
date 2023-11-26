
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/main/main_screen.dart';
import 'package:to_do_list/main/posting_screen/posting_screen.dart';
import 'package:to_do_list/provider/comment_provider.dart';
import 'package:to_do_list/provider/home_screen_provider.dart';
import 'package:to_do_list/provider/main_screen_provider.dart';
import 'package:to_do_list/provider/thumbnail_image_provider.dart';
import 'package:to_do_list/provider/userPosts_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) =>  thumbnailImageProvider()),
      ChangeNotifierProvider(create: (BuildContext context) =>  Main_screen_provider()),
      ChangeNotifierProvider(create: (BuildContext context) =>  HomeProvider()),
      ChangeNotifierProvider(create: (BuildContext context) =>  UserPosts_Provider()),
      ChangeNotifierProvider(create: (BuildContext context) =>  CommentProvider()),


    ],
    child : const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner : false,
        initialRoute: '/',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          MainScreen.routeName: (context) => const MainScreen(),
          PostingScreen.routeName: (context) => const PostingScreen(),  

      },
    );
  }
}
