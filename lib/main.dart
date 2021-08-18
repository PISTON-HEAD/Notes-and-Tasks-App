import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/MyApp/terms_conditions.dart';
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
      home: TermsAndConditions(),
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

// class ScreenSplash extends StatefulWidget {
//
//   @override
//   _ScreenSplashState createState() => _ScreenSplashState();
// }
//
// class _ScreenSplashState extends State<ScreenSplash> {
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       nextScreen: profile_Screen(),
//       splashTransition: SplashTransition.rotationTransition,
//       splash: Icon(Icons.article_outlined),
//       centered: true,
//       animationDuration: Duration(seconds: 2),
//       splashIconSize: 25,
//     );
//   }
// }
