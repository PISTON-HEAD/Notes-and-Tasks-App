import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/LogScreens/titleSearcher.dart';
import 'package:to_do_list/MyApp/aboutTheApp.dart';
import 'package:to_do_list/MyApp/todoList.dart';
import 'package:to_do_list/widgets/customWidgets.dart';
import 'NotesveriWer.dart';
import 'notesPage.dart';

class profile_Screen extends StatefulWidget {
  @override
  _profile_ScreenState createState() => _profile_ScreenState();
}

class _profile_ScreenState extends State<profile_Screen>
    with SingleTickerProviderStateMixin {
  var theList;
  AnimationController _controller;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool k = true;
  var checkValue = true;
  List getter = [];
  Duration dur = Duration(milliseconds: 500);
  List checkBoxValue = [];
  String storing, changer = "";

  Color primaryColor = Colors.black;
  Color noteColor = Colors.white;
  Color noteColor2 = Colors.white70;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("My Task")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      getter = value["Task List"];
      checkBoxValue = value["Checker"];
      print("The inputList ater  server in screen 1:  $getter");
    });
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "Notes",
                style: appBar_Style,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.limeAccent,
                      size: 28.8,
                    ),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(
                      FontAwesomeIcons.solidClipboard,
                      color: Colors.grey,
                      size: 28.8,
                    ),
                    onPressed: () {
                      print("prophile page");
                      setState(() {
                        FirebaseFirestore.instance
                            .collection("My Task")
                            .doc(auth.currentUser.uid)
                            .get()
                            .then((value) {
                          print(
                              "This is the list on server in screen 1: ${value["Task List"]}");
                          getter = value["Task List"];
                          checkBoxValue = value["Checker"];
                          print(
                              "The inputList after  server in screen 1:  $getter");
                        });
                      });
                      Future.delayed(dur).then((value) {
                        print("$dur sec delayed");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => todoListCreation(
                                      getterList: getter,
                                      checkBoxValue: checkBoxValue,
                                    )));
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: CupertinoColors.black,
          toolbarHeight: 85,
          elevation: 10,
          actions: [
            PopupMenuButton(
              color: CupertinoColors.systemTeal,
              icon: Icon(
                Icons.more_vert_sharp,
                color: Colors.white70,
                size: 30,
              ),
              onSelected: (value) async {
                if (value == 0) {
                  print("About App");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppInfo(value: value)));
                } else if (value == 1) {
                  print("About Developers");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppInfo(value: value)));
                } else if (value == 3) {
                  print("Log Out");
                  auth.signOut();
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  print(shared.getString("LoggedIn"));
                  shared.setString("LoggedIn", "false");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn_Page()));
                } else if (value == 2) {
                  print("Privacy Policy");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppInfo(value: value)));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("About App"),
                  value: 0,
                ),
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("About Developers"),
                  value: 1,
                ),
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("Privacy Policy"),
                  value: 2,
                ),
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("Log Out"),
                  value: 3,
                ),
              ],
            ),
          ],
        ),
        backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyanAccent,
          highlightElevation: 20,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotesScreen()));
          },
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.black,
            size: 25,
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 2,
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: searchTitle());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: CupertinoColors.black,
                        size: 25,
                      ),
                      Text(
                        "Search with Title Name",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                      border: Border.all(color: Colors.cyanAccent, width: 3)),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 45),
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(
                  "https://i.pinimg.com/originals/4f/6d/05/4f6d052bb1b26150115888ea06d4c106.jpg",),
                fit: BoxFit.cover,
              )),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("My Task")
                      .doc(auth.currentUser.uid)
                      .collection("Notes")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount:
                          snapshot.hasData ? snapshot.data.docs.length : 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print(snapshot.data.docs[index]["Title"]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SeeNote(
                                          getDoc: snapshot.data.docs[index],
                                        )));
                          },
                          onLongPress: () {
                            buildShowDialog(context, snapshot, index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 28, 28, 30),
                                border: Border.all(
                                    color: Colors.cyanAccent, width: 2.5),
                                borderRadius: BorderRadius.circular(10)),
                            //height: 180,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      55.0), //here is the padding for content
                              child: ListTile(
                                autofocus: true,
                                subtitle: Text(
                                  snapshot.data.docs[index]["Content"],
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 152, 151, 158),
                                      fontWeight: FontWeight.w800,
                                      decorationThickness: 2.5,
                                      fontSize: 12,
                                      fontFamily: "Merriweather"),
                                ),
                                title: Text(
                                  snapshot.data.docs[index]["Title"].toString().toLowerCase(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(252, 252, 254, 0.7),
                                      fontWeight: FontWeight.bold,
                                      decorationThickness: 2.5,
                                      fontSize: 20,
                                      fontFamily: "ZenTokyoZoo"),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context,
      AsyncSnapshot<QuerySnapshot<Object>> snapshot, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("  Delete Note ?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {
                    print("Deleting");
                    snapshot.data.docs[index].reference
                        .delete()
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  autofocus: true,
                  style: ButtonStyle(),
                  child: Text("Delete")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
            ],
          ),
        );
      },
    );
  }
}