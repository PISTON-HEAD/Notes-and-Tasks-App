import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/LogScreens/titleSearcher.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Notes",
                style: appBar_Style,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5.5,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.limeAccent,
                      size: 30,
                    ),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(

                      FontAwesomeIcons.solidClipboard,
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
            IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
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
          backgroundColor: Colors.cyanAccent,
          highlightElevation: 20,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NotesScreen()));
          },
          child: Icon(FontAwesomeIcons.plus,color: Colors.white,size: 30,),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://i.pinimg.com/564x/02/c3/4b/02c34bd8761d9c04596bf4434359458e.jpg"),fit: BoxFit.cover)
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("My Task")
                  .doc(auth.currentUser.uid)
                  .collection("Notes")
                  .snapshots(),
              builder: (context, snapshot) {
                return GridView.builder(
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: snapshot.hasData ? snapshot.data.docs.length+1 : 0,
                  itemBuilder: (context, index) {
                    return index == 0 && snapshot.hasData ?GestureDetector(
                      onTap: (){
                        showSearch(context: context, delegate: searchTitle());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.cyanAccent,width: 2.5),
                            //color: Colors.yellow[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        //height: 180,
                        margin: EdgeInsets.all(10),
                        child: Icon(Icons.search_sharp,color: Colors.amber,size: 70,),
                      ),
                    ) : GestureDetector(
                      onTap: () {
                        print(snapshot.data.docs[index-1]["Title"]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeeNote(
                                      getDoc: snapshot.data.docs[index-1],
                                    )));
                      },
                      onLongPress: (){
                        buildShowDialog(context, snapshot, index-1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.accents[index-1],
                            border: Border.all(color: Colors.cyanAccent,width: 2.5),
                            //color: Colors.yellow[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        //height: 180,
                        margin: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Positioned(
                              top: MediaQuery.of(context).size.height/4.85,
                                left: MediaQuery.of(context).size.width/50,
                                child: Text(snapshot.data.docs[index-1]["Time"].toString().substring(0,16),style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),)
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/5.65,
                              left: MediaQuery.of(context).size.width/3.1,
                              child:
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.trash,

                                ),
                                onPressed: () {
                                  buildShowDialog(context, snapshot, index-1);
                                },
                              )
                            ),
                            ListTile(
                              autofocus: true,
                              subtitle:Text(
                                snapshot.data.docs[index-1]["Content"],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800,
                                    decorationThickness: 2.5,
                                    //backgroundColor: Colors.white,
                                    fontSize: 12,
                                    //"pacifico"
                                    fontFamily:"Merriweather" ),
                              ),
                              title: Text(
                                snapshot.data.docs[index-1]["Title"],
                                style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 2.5,
                                    //backgroundColor: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "ZenTokyoZoo"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context, AsyncSnapshot<QuerySnapshot<Object>> snapshot, int index) {
    return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "  Delete Note ?"),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            print("Deleting");
                                            snapshot
                                                .data.docs[index].reference
                                                .delete()
                                                .whenComplete(() =>
                                                Navigator.of(context)
                                                    .pop());
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



/*
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/LogScreens/titleSearcher.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Notes",
                style: appBar_Style,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5.5,
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.limeAccent,
                      size: 30,
                    ),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(

                      FontAwesomeIcons.solidClipboard,
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
            IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
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
          backgroundColor: Colors.cyanAccent,
          highlightElevation: 20,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NotesScreen()));
          },
          child: Icon(FontAwesomeIcons.plus,color: Colors.white,size: 30,),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://i.pinimg.com/564x/02/c3/4b/02c34bd8761d9c04596bf4434359458e.jpg"),fit: BoxFit.cover)
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("My Task")
                  .doc(auth.currentUser.uid)
                  .collection("Notes")
                  .snapshots(),
              builder: (context, snapshot) {
                return GridView.builder(
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: snapshot.hasData ? snapshot.data.docs.length+1 : 0,
                  itemBuilder: (context, index) {
                    return index == 0 && snapshot.hasData ?GestureDetector(
                      onTap: (){
                        showSearch(context: context, delegate: searchTitle());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.cyanAccent,width: 2.5),
                            //color: Colors.yellow[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        //height: 180,
                        margin: EdgeInsets.all(10),
                        child: Icon(Icons.search_sharp,color: Colors.amber,size: 70,),
                      ),
                    ) : GestureDetector(
                      onTap: () {
                        print(snapshot.data.docs[index-1]["Title"]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeeNote(
                                      getDoc: snapshot.data.docs[index-1],
                                    )));
                      },
                      onLongPress: (){
                        buildShowDialog(context, snapshot, index-1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.accents[index-1],
                            border: Border.all(color: Colors.cyanAccent,width: 2.5),
                            //color: Colors.yellow[200],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        //height: 180,
                        margin: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Positioned(
                              top: MediaQuery.of(context).size.height/4.85,
                                left: MediaQuery.of(context).size.width/50,
                                child: Text(snapshot.data.docs[index-1]["Time"].toString().substring(0,16),style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),)
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/5.65,
                              left: MediaQuery.of(context).size.width/3.1,
                              child:
                              IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.trash,

                                ),
                                onPressed: () {
                                  buildShowDialog(context, snapshot, index-1);
                                },
                              )
                            ),
                            ListTile(
                              autofocus: true,
                              subtitle:Text(
                                snapshot.data.docs[index-1]["Content"],
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w800,
                                    decorationThickness: 2.5,
                                    //backgroundColor: Colors.white,
                                    fontSize: 12,
                                    //"pacifico"
                                    fontFamily:"Merriweather" ),
                              ),
                              title: Text(
                                snapshot.data.docs[index-1]["Title"],
                                style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 2.5,
                                    //backgroundColor: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "ZenTokyoZoo"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context, AsyncSnapshot<QuerySnapshot<Object>> snapshot, int index) {
    return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      "  Delete Note ?"),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            print("Deleting");
                                            snapshot
                                                .data.docs[index].reference
                                                .delete()
                                                .whenComplete(() =>
                                                Navigator.of(context)
                                                    .pop());
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




 */