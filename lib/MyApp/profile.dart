import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
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
  String ownerName;
  bool k = true;
  var checkValue = true;
  List getter = [];
  Duration dur = Duration(milliseconds: 400);
  List checkBoxValue = [];
  String storing, changer = "";

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("My Task")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      print("This is the list on server in screen 1: ${value["Task List"]}");
      getter = value["Task List"];
      checkBoxValue = value["Checker"];
      print("The inputList ater  server in screen 1:  $getter");
    });
    //to get the current users name on appBar

    ownerName = auth.currentUser.displayName;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$ownerName",
              style: appBar_Style,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Icon(
                    FontAwesomeIcons.solidClipboard,
                    color: Colors.limeAccent,
                    size: 30,
                  ),
                ),
                MaterialButton(
                  autofocus: true,
                  child: Icon(
                    FontAwesomeIcons.stickyNote,
                    color: Colors.grey,
                    size: 30,
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
                            "The inputList ater  server in screen 1:  $getter");
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
          IconButton(
            icon: Icon(
              Icons.add_to_home_screen_outlined,
              color: Colors.white70,
            ),
            onPressed: () async {
              auth.signOut();
              SharedPreferences shared = await SharedPreferences.getInstance();
              print(shared.getString("LoggedIn"));
              shared.setString("LoggedIn", "false");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignIn_Page()));
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotesScreen()));
        },
        child: Icon(FontAwesomeIcons.evernote),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:  FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).collection("Notes").snapshots(),
        builder: (context, snapshot) {
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: snapshot.hasData?snapshot.data.docs.length:0,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  print(snapshot.data.docs[index]["Title"]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeeNote(getDoc:snapshot.data.docs[index] ,)));
                },
                child: Container(
                  height: 150,
                  margin: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text(snapshot.data.docs[index]["Title"],style: TextStyle(
                            color: Colors.black,
                            fontWeight:FontWeight.w900,
                            fontSize: 15,
                            fontFamily: "Cinzel"
                        ),),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}

/*
Text(snapshot.data.docs[index]["Title"],style: TextStyle(
                        color: Colors.black,
                        fontWeight:FontWeight.w900,
                        fontSize: 15,
                        fontFamily: "Cinzel"
                      ),),







 */