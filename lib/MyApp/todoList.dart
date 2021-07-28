import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/MyApp/aboutTheApp.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class todoListCreation extends StatefulWidget {
  final getterList;
  final checkBoxValue;

  const todoListCreation({Key key, this.getterList, this.checkBoxValue})
      : super(key: key);
  @override
  _todoListCreationState createState() =>
      _todoListCreationState(getterList, checkBoxValue);
}

class _todoListCreationState extends State<todoListCreation> {
  TextEditingController editingController = new TextEditingController();
  String ownerName;
  List inputList = [];
  String theList = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  final getterList;
  final checkBoxValue;
  _todoListCreationState(this.getterList, this.checkBoxValue);
  List checkBoxList = [];
  bool checker = !true;
  List timeStamp = [];

  taskMaker() {
    FirebaseFirestore.instance
        .collection("My Task")
        .doc(auth.currentUser.uid)
        .set({
      "Task List": inputList,
      "Checker": checkBoxList,
      "Time Stamp":timeStamp,
    });
  }

  @override
  void initState() {
    if (getterList != null) {
      checkBoxList = checkBoxValue;
      print("The getter List on screen 1  in screen 2:$getterList");
      inputList = getterList;
    }
    FirebaseFirestore.instance
        .collection("My Task")
        .doc(auth.currentUser.uid)
        .get()
        .then((value) {
      print("This is the list on server: ${value["Task List"]}");
      inputList = value["Task List"];
      checkBoxList = value["Checker"];
      timeStamp = value["Time Stamp"];
      print("The checker Value: $checkBoxList");
      print("The inputList after  server: $inputList");
    });
    // TODO: implement initState
    super.initState();
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
                "Tasks",
                style: appBar_Style,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => profile_Screen()));
                    },
                    child: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.grey,
                      size: 28.8,
                    ),
                  ),
                  MaterialButton(
                      autofocus: true,
                      child: Icon(
                        FontAwesomeIcons.solidClipboard,
                        color: Colors.limeAccent,
                        size: 28.8,
                      ),
                      onPressed: () {}),
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
        ), //u normally do the appbar
        backgroundColor: CupertinoColors.label,
        body: inputList == null
            ? Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/originals/4f/6d/05/4f6d052bb1b26150115888ea06d4c106.jpg",
                  ),
                  fit: BoxFit.cover,
                )
                    //https://cdn.wallpapersafari.com/5/69/ZFWaoE.jpg
                    //https://img.freepik.com/free-photo/old-black-background-grunge-texture-dark-wallpaper-blackboard-chalkboard-room-wall_1258-28313.jpg?size=626&ext=jpg
                    ),
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/originals/4f/6d/05/4f6d052bb1b26150115888ea06d4c106.jpg",
                  ),
                  fit: BoxFit.cover,
                )
                    //https://cdn.wallpapersafari.com/5/69/ZFWaoE.jpg
                    //https://img.freepik.com/free-photo/old-black-background-grunge-texture-dark-wallpaper-blackboard-chalkboard-room-wall_1258-28313.jpg?size=626&ext=jpg
                    ),
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  scrollDirection: Axis.vertical,
                  itemCount: inputList.length,
                  itemBuilder: (context, index) {
                    return inputList.isEmpty
                        ? Container(
                            color: Colors.red[300],
                          )
                        : Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 15, right: 15),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 20,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black87,
                                      border: Border.all(
                                        color: Colors.cyanAccent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: checkBoxList == []
                                        ? null
                                        : Checkbox(
                                            side: BorderSide(
                                              color: Colors.white,
                                            ),
                                            autofocus: true,
                                            activeColor: Colors.cyanAccent,
                                            splashRadius: 20,
                                            value: checkBoxList[index],
                                            onChanged: (value) {
                                              setState(() {
                                                print(
                                                    "The check Box on pressed:  $checkBoxList}");
                                                if (checkBoxList[index] ==
                                                    false) {
                                                  checkBoxList[index] = true;
                                                } else {
                                                  checkBoxList[index] = false;
                                                }
                                                taskMaker();
                                              });
                                            },
                                          ),
                                    selected: true,
                                    onTap: (){
                                      editTask(context, index);
                                    },
                                    onLongPress: () {
                                      editTask(context, index);
                                    },
                                    autofocus: true,
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          inputList.removeAt(index);
                                          checkBoxList.removeAt(index);
                                          timeStamp.removeAt(index);
                                          print(timeStamp);
                                          taskMaker();
                                        });
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.red,
                                      ),
                                    ),
                                    title: Text(
                                      " ${index + 1})  ${inputList[index].toString()}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Merriweather",
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                          );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (buildContext) {
                  return AlertDialog(
                    title: Text(
                      "Enter the task",
                      style: TextStyle(
                        fontFamily: "Acme",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    scrollable: true,
                    content: TextFormField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      autofocus: true,
                      autocorrect: true,
                      onChanged: (text) {
                        theList = text;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        color: Colors.cyanAccent,
                        child: Text(
                          "Save",
                          style: TextStyle(),
                        ),
                        onPressed: () {
                          if (theList == "") {
                            theList = "";
                          } else {
                            setState(() {
                              inputList.add(theList);
                              theList = "";
                              checkBoxList.add(false);
                              timeStamp.add(DateTime.now().toString().substring(0,16));
                              taskMaker();
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
          backgroundColor: Colors.cyanAccent,
          highlightElevation: 20,
          autofocus: true,
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Future<dynamic> editTask(BuildContext context, int index) {
    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          editingController =
                                              TextEditingController(
                                                  text: inputList[index]);
                                          return AlertDialog(
                                            title: Text("Edit",style: TextStyle(
                                              fontFamily: "Acme",
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                            content: TextFormField(
                                              autofocus: true,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: null,
                                              controller: editingController,
                                              onChanged: (value) {
                                                theList = value;
                                              },
                                            ),

                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text("""Edited on: 
${timeStamp[index].toString().substring(8,10)}${timeStamp[index].toString().substring(4,9)}${timeStamp[index].toString().substring(1,4)}${timeStamp[index].toString().substring(10)}""",style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Cinzel"
                                                  ),),
                                                  MaterialButton(
                                                    child: Text("Save",style:TextStyle(
                                                      fontSize: 15,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: "Merriweather",
                                                    ),),
                                                    color: Colors.cyanAccent,
                                                    onPressed: () {
                                                      setState(() {
                                                        if (theList.length != 0) {
                                                          inputList[index] =
                                                              theList;
                                                          //checkBoxList[index] = false;
                                                          timeStamp[index] = (DateTime.now().toString().substring(0,16));
                                                          taskMaker();
                                                        }
                                                        theList = "";
                                                      });
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
  }
}

