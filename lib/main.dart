
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_do_list/main/main_screen.dart';
import 'package:to_do_list/provider/to_do_list_Provider.dart';
import 'firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) =>  ToDoListProvider()),
      
    ],
    child : const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner : false,
          initialRoute: '/',
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            MainScreen.routeName: (context) => MainScreen(),
            
          },
      
      ),
    );
  }
}
