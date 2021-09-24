import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/forgot_pass.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/authenticate/GoogleAuthenticate.dart';
import 'package:to_do_list/authenticate/firebaseAuth.dart';
import 'package:to_do_list/widgets/customWidgets.dart';


class SignIn_Page extends StatefulWidget {
  @override
  _SignIn_PageState createState() => _SignIn_PageState();
}

class _SignIn_PageState extends State<SignIn_Page> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();

  bool seePassword = true;
  IconData passwordVisibility = Icons.visibility_off;

  bool switcher = true;
  bool screenValue = !true;
  String errorMsg;

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //signingUp
  signMeUp() {
    if (formKey.currentState.validate()) {
      signUp(emailController.text, passwordController.text,
              userNameController.text)
          .then((value) async {
        if (value != null) {
          setState(() {
            screenValue = true;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("Error message : $errorMsg");
              }
            }
            //errorMsg = value;
          });
        } else {
          setState(() {
            screenValue = !true;
          });
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          print(sharedPreferences.getString("LoggedIn"));
          print("next screen");
          Navigator.push(context, MaterialPageRoute(builder: (context) =>profile_Screen()));
        }
      });
    }
  }

  signMeIn() {
    if (formKey.currentState.validate()) {
      logInUser(emailController.text, passwordController.text).then((value) async {
        if (value != null) {
          setState(() {
            screenValue = true;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
                print("the error message $i  $errorMsg");
              }
              if(errorMsg == "The password is invalid or the user does not have a password."){
                errorMsg = "The password entered is invalid";
              }else if(errorMsg == "There is no user record corresponding to this identifier. The user may have been deleted."){
                errorMsg = "User id is invalid";
              }
            }
          });
        } else {
          FirebaseFirestore.instance
              .collection("Ordinary_Users")
              .doc(firebaseAuth.currentUser.uid)
              .update({
            "Password": passwordController.text,
            "Last SignedIn":DateTime.now(),
          });
          // setState(() {
          //   loader = false;
          // });
          screenValue = false;
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          print(sharedPreferences.getString("LoggedIn"));
          print("NextScreen..");
          Navigator.push(context, MaterialPageRoute(builder: (context) => profile_Screen()));
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          appBar: appBar_Main(context, "Notes and Tasks Pro", Colors.black),
          backgroundColor: primaryColor,
          body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 00.0, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      switcher == true ? " Sign Up " : "Log In",
                      style: customStyle(
                          Colors.white, 35, FontWeight.w800, "Merriweather"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: screenValue == true ? 60 : 0,
                        width: MediaQuery.of(context).size.width,
                        child: screenValue == true
                            ? Container(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          child: Center(
                            child: Text(
                              "!!! $errorMsg !!!",
                              style: TextStyle(
                                color: Colors.yellow, //red[400],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                            : Text(""),
                      ),
                    ),
                    Text(
                      switcher == true
                          ? "If You are a new user, Create your account by entering your email and a password"
                          : "  Enter your account email and password to SignIn to your account  ",
                      style: customStyle(
                          Colors.lightGreen, 17, FontWeight.w600, "Acme"),
                      textAlign: TextAlign.center,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 30),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  border: Border.all(color: Colors.blue)),
                              child: TextFormField(
                                cursorColor: Colors.limeAccent,
                                cursorWidth: 4,
                                controller: emailController,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value.contains(" ")) {
                                    return "Enter an email without space";
                                  } else if(RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)) {
                                    return null;
                                  }else{
                                    return "Enter valid Email";
                                  }
                                },
                                style: textFieldStyle,
                                decoration: textInputDecoration(
                                    "Email", Icons.alternate_email),
                              ),
                            ),
                            SizedBox(height: 10),
                            switcher == true
                                ? Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  border: Border.all(color: Colors.blue)),
                              child: TextFormField(
                                cursorColor: Colors.limeAccent,
                                cursorWidth: 4,
                                validator: (value) {
                                  return value.toString().length <= 4
                                      ? "Minimum character required is 5"
                                      : null;
                                },
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: userNameController,
                                style: textFieldStyle,
                                decoration: textInputDecoration(
                                    "username", Icons.person_rounded),
                              ),
                            )
                                : SizedBox(),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  border: Border.all(color: Colors.blue)),
                              child: TextFormField(
                                cursorColor: Colors.limeAccent,
                                cursorWidth: 4,
                                obscureText: seePassword,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  String val = value.toString().toLowerCase();
                                  int charCounter = 0;
                                  if (value.isEmpty || value.length < 8) {
                                    return "character required is 8";
                                  } else {
                                    for (int i = 0; i < value.length; i++) {
                                      if (val.codeUnitAt(i) >= 97 &&
                                          val.codeUnitAt(i) <= 122) {}
                                      else {
                                        charCounter++;
                                      }
                                    }
                                    return charCounter != 0
                                        ? null
                                        : "Enter characters other than alphabets, ex: 1,/,-...";
                                  }
                                },
                                controller: passwordController,
                                style: textFieldStyle,
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                                  hintText: "password",
                                  labelText: "password",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.greenAccent,
                                      width: 3,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisibility,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (seePassword == true) {
                                          passwordVisibility = Icons.visibility;
                                          seePassword = !true;
                                        } else {
                                          passwordVisibility = Icons.visibility_off;
                                          seePassword = true;
                                        }
                                      });
                                    },
                                  ),
                                  hintStyle: textFieldStyle,
                                  labelStyle: textFieldStyle,
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.key,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            switcher == true?SizedBox(height: 10):SizedBox(),
                            switcher == true
                                ? Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  border: Border.all(color: Colors.blue)),
                              child: TextFormField(
                                cursorColor: Colors.limeAccent,
                                cursorWidth: 4,
                                obscureText: true,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return value == passwordController.text
                                      ? null
                                      : "passwords don't match";
                                },
                                controller: confirmPassController,
                                style: textFieldStyle,
                                decoration: textInputDecoration(
                                    "password confirmation",
                                    Icons.admin_panel_settings_rounded),
                              ),
                            )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ForgotPassword()));
                                },
                                    child: Text("forgot password ?",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),)),
                              ],
                            ),
                            switcher == true?SizedBox(
                              height: 8,
                            ):SizedBox(),
                            //signUp / Login
                            MaterialButton(
                                color: Colors.greenAccent,
                                minWidth: double.maxFinite,
                                autofocus: true,
                                splashColor: Colors.green,
                                hoverColor: Colors.blueAccent,
                                child: Text(
                                  switcher == true ? " Sign-Up " : " Log-In",
                                  style: buttonStyle(Colors.white),
                                ),
                                onPressed: () {
                                  if (switcher == true) {
                                    print("SigningUp..");
                                    signMeUp();
                                  } else {
                                    print("Logging In..");
                                    signMeIn();
                                  }
                                }),
                            SizedBox(
                              height: 3,
                            ),
                            MaterialButton(
                              color: Colors.indigoAccent,
                              minWidth: double.maxFinite,
                              autofocus: true,
                              splashColor: Colors.indigo,
                              hoverColor: Colors.green,
                              child: Text("Google Sign In",style: buttonStyle(Colors.white),),
                              onPressed: () async{
                                signInWithGoogle().then((value) async {
                                  if(value == null){
                                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                    sharedPreferences.setString("LoggedIn", "true");
                                    print(sharedPreferences.getString("LoggedIn"));
                                    print("next screen");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>profile_Screen()));
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  switcher == true
                                      ? "Already have an account ? "
                                      : "Don't have an account ?",
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (switcher == true) {
                                        print("Login");
                                        switcher = !true;
                                      } else {
                                        print("SignUp");
                                        switcher = true;
                                      }
                                    });
                                  },
                                  child: Text(
                                    switcher == true ? "LogIn" : "SignUp",
                                    style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop:(){
        return showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            content: Text("Do you want to exit the App ?"),
            actions: [
              TextButton(
                child: Text("No"),
                onPressed: ()=>Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Exit"),
                onPressed: ()=>Navigator.of(context).pop(true),
              ),
            ],
          );
        });
      },
    );
  }
}