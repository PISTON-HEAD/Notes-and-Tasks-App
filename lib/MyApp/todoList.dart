import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class todoListCreation extends StatefulWidget {
  final getterList;
  final checkBoxValue;

  const todoListCreation({Key key, this.getterList, this.checkBoxValue}) : super(key: key);
  @override
  _todoListCreationState createState() => _todoListCreationState(getterList,checkBoxValue);
}

class _todoListCreationState extends State<todoListCreation> {
  TextEditingController editingController = new TextEditingController();
  String ownerName;
  List inputList = [];
  String theList = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  final getterList;
  final checkBoxValue;
  _todoListCreationState(this.getterList,this.checkBoxValue);
  List checkBoxList = [];
  bool checker = !true;

  taskMaker(){
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).set({
      "Task List":inputList,
      "Checker":checkBoxList,
    });
  }

  @override
  void initState() {
    if(getterList != null ){
      checkBoxList = checkBoxValue;
      print("The getter List on screen 1  in screen 2:$getterList");
    inputList = getterList;
    }
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).get().then((value) {
      print("This is the list on server: ${value["Task List"]}");
      inputList = value["Task List"];
      checkBoxList = value["Checker"];
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tasks",
                style: appBar_Style,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/5.5,
                  ),
                  MaterialButton(
                    onPressed: (){
                      //Navigator.of(context).pop();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => profile_Screen()));
                    },
                    child: Icon(FontAwesomeIcons.stickyNote,color: Colors.grey,size: 30,),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(FontAwesomeIcons.solidClipboard,color: Colors.limeAccent,size: 30,),
                    onPressed: () {}
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
              onSelected: (value)async{
                if (value == 0) {
                  print("privacy policy");
                } else if (value == 1) {
                  print("About");
                } else if (value == 2) {
                  print("Log Out");
                  auth.signOut();
                  SharedPreferences shared =
                  await SharedPreferences.getInstance();
                  print(shared.getString("LoggedIn"));
                  shared.setString("LoggedIn", "false");
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn_Page()));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("Privacy Policy"),
                  value: 0,
                ),
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("About"),
                  value: 1,
                ),
                PopupMenuItem(
                  textStyle: popStyle(),
                  child: Text("Log Out"),
                  value: 2,
                ),
              ],
            ),
          ],
        ), //u normally do the appbar
            backgroundColor: CupertinoColors.label,
        body: inputList == null
            ? Container()
            : ListView.builder(
                addAutomaticKeepAlives: false,
                scrollDirection: Axis.vertical,
                itemCount: inputList.length,
                itemBuilder: (context, index) {
                  return inputList.isEmpty
                      ? Container(color: Colors.red[300],)
                      : Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 20,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    border: Border.all(color: Colors.cyanAccent,
                                    width: 2,),
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                   leading:checkBoxList==[] ? null:Checkbox(
                                     side: BorderSide(
                                       color: Colors.white,
                                     ),
                                     autofocus: true,
                                    activeColor: Colors.cyanAccent,
                                    splashRadius: 20,
                                    value: checkBoxList[index],
                                    onChanged: (value){
                                    setState(() {
                                      print("The check Box on pressed:  $checkBoxList}");
                                      if(checkBoxList[index] == false){
                                        checkBoxList[index] = true;
                                      }else{
                                        checkBoxList[index] = false;
                                      }
                                      taskMaker();
                                    });
                                  },),
                                  selected: true,
                                  onLongPress: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          editingController = TextEditingController(text: inputList[index]);
                                          return AlertDialog(
                                            content: TextFormField(
                                              maxLines: 3,
                                              controller:editingController,
                                              onChanged: (value){
                                                theList = value;
                                              },
                                            ),
                                            actions: [
                                              MaterialButton(
                                                child: Text("Save"),
                                                color: Colors.cyanAccent,
                                                onPressed: () {
                                                  setState(() {
                                                    if(theList.length != 0){
                                                      inputList[index] = theList;
                                                      //checkBoxList[index] = false;
                                                      taskMaker();
                                                    }
                                                    theList = "";
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  autofocus: true,
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        inputList.removeAt(index);
                                        checkBoxList.removeAt(index);
                                        taskMaker();
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    " ${index + 1}).  ${inputList[index].toString()}",
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
                      maxLines: 3,
                      //onSubmitted: ,
                      autocorrect: true,
                      onChanged: (text) {
                        theList = text;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        color: Colors.cyanAccent,
                        child: Text("Save",style: TextStyle(),),
                        onPressed: () {
                          if(theList==""){
                            theList="";
                          }else{setState(() {
                            inputList.add(theList);
                            theList = "";
                            checkBoxList.add(false);
                            taskMaker();
                          });}
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
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}





/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class todoListCreation extends StatefulWidget {
  final getterList;
  final checkBoxValue;

  const todoListCreation({Key key, this.getterList, this.checkBoxValue}) : super(key: key);
  @override
  _todoListCreationState createState() => _todoListCreationState(getterList,checkBoxValue);
}

class _todoListCreationState extends State<todoListCreation> {
  TextEditingController editingController = new TextEditingController();
  String ownerName;
  List inputList = [];
  String theList = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  final getterList;
  final checkBoxValue;
  _todoListCreationState(this.getterList,this.checkBoxValue);
  List checkBoxList = [];
  bool checker = !true;

  taskMaker(){
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).set({
      "Task List":inputList,
      "Checker":checkBoxList,
    });
  }

  @override
  void initState() {
    if(getterList != null ){
      checkBoxList = checkBoxValue;
      print("The getter List on screen 1  in screen 2:$getterList");
    inputList = getterList;
    }
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).get().then((value) {
      print("This is the list on server: ${value["Task List"]}");
      inputList = value["Task List"];
      checkBoxList = value["Checker"];
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "To Do List",
                style: appBar_Style,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/5.5,
                  ),
                  MaterialButton(
                    onPressed: (){
                      //Navigator.of(context).pop();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => profile_Screen()));
                    },
                    child: Icon(FontAwesomeIcons.stickyNote,color: Colors.grey,size: 30,),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(FontAwesomeIcons.solidClipboard,color: Colors.limeAccent,size: 30,),
                    onPressed: () {}
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
        ), //u normally do the appbar
            backgroundColor: CupertinoColors.label,
        body: inputList == null
            ? Container()
            : ListView.builder(
                addAutomaticKeepAlives: false,
                scrollDirection: Axis.vertical,
                itemCount: inputList.length,
                itemBuilder: (context, index) {
                  return inputList.isEmpty
                      ? Container(color: Colors.red[300],)
                      : Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 20,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black87,
                                    border: Border.all(color: Colors.white60),
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                   leading:checkBoxList==[] ? null:Checkbox(
                                     autofocus: true,
                                    activeColor: Colors.greenAccent,
                                    splashRadius: 20,
                                    value: checkBoxList[index],
                                    onChanged: (value){
                                    setState(() {
                                      print("The check Box on pressed:  $checkBoxList}");
                                      if(checkBoxList[index] == false){
                                        checkBoxList[index] = true;
                                      }else{
                                        checkBoxList[index] = false;
                                      }
                                      taskMaker();
                                    });
                                  },),
                                  selected: true,
                                  onLongPress: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          editingController = TextEditingController(text: inputList[index]);
                                          return AlertDialog(
                                            title: Text("Edit your text"),
                                            content: TextFormField(
                                              maxLines: 3,
                                              controller:editingController,
                                              onChanged: (value){
                                                theList = value;
                                              },
                                            ),
                                            actions: [
                                              MaterialButton(
                                                child: Text("pop"),
                                                onPressed: () {
                                                  setState(() {
                                                    if(theList.length != 0){
                                                      inputList[index] = theList;
                                                      //checkBoxList[index] = false;
                                                      taskMaker();
                                                    }
                                                    theList = "";
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  autofocus: true,
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        inputList.removeAt(index);
                                        checkBoxList.removeAt(index);
                                        taskMaker();
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                  title: Text(
                                    " ${index + 1}).  ${inputList[index].toString()}",
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
                      maxLines: 3,
                      //onSubmitted: ,
                      autocorrect: true,
                      onChanged: (text) {
                        theList = text;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        color: Colors.grey,
                        child: Text("Save",style: TextStyle(),),
                        onPressed: () {
                          if(theList==""){
                            theList="";
                          }else{setState(() {
                            inputList.add(theList);
                            theList = "";
                            checkBoxList.add(false);
                            taskMaker();
                          });}
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
            FontAwesomeIcons.clipboardList,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
    );
  }
}

 */