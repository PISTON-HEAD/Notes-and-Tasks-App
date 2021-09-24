import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'LogScreens/welcome.dart';
import 'MyApp/profile.dart';
import 'package:flutter/services.dart'; //For using SystemChrome


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  String logger = sharedPreferences.getString("LoggedIn");
  String id = sharedPreferences.getString("id");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  print(logger);
  print("user id => $id");
  runApp(id == null ? MyApp() : logger == "true" ? SignedInApp() : SignUp());
}

class SignUp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes And Task Pro',
      debugShowCheckedModeBanner:false,
      home: SignIn_Page(),
    );
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes And Task Pro',
      debugShowCheckedModeBanner:false,
      home: WelcomeScreen(),
    );
  }
}


class SignedInApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes And Task Pro',
      debugShowCheckedModeBanner:false,
      home: profile_Screen(),
    );
  }
}


