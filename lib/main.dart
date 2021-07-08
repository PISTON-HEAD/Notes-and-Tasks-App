import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LogScreens/SignIn_Screen.dart';
import 'MyApp/profile.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  String logger = sharedPreferences.getString("LoggedIn");
  String id = sharedPreferences.getString("id");
  print(logger);
  print(id);
  runApp(logger == "true"?SignedInApp():MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignIn_Page(),
    );
  }
}


class SignedInApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: profile_Screen(),
    );
  }
}