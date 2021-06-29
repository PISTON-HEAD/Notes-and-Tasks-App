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
    ownerName = auth.currentUser.displayName;
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
                "$ownerName",
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
                    child: Icon(FontAwesomeIcons.solidClipboard,color: Colors.grey,size: 30,),
                  ),
                  MaterialButton(
                    autofocus: true,
                    child: Icon(FontAwesomeIcons.stickyNote,color: Colors.limeAccent,size: 30,),
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
                                            content: TextField(
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
                      "Enter ur list",
                      style: appBar_Style,
                    ),
                    scrollable: true,
                    content: TextField(
                      autocorrect: true,
                      onChanged: (text) {
                        theList = text;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        child: Text("pop"),
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
            Icons.add,
            color: Colors.black,
            size: 35,
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
import 'package:recipe_club/widgets/customWidgets.dart';

class todoListCreation extends StatefulWidget {
  final getterList;
  final checkBoxValue;

  const todoListCreation({Key key, this.getterList, this.checkBoxValue}) : super(key: key);
  @override
  _todoListCreationState createState() => _todoListCreationState(getterList,checkBoxValue);
}

class _todoListCreationState extends State<todoListCreation> {
  TextEditingController editingController = new TextEditingController();

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
        appBar: appBar_Main(
            context, "ToDo List", Colors.teal), //u normally do the appbar
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
                                            content: TextField(
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
                      "Enter ur list",
                      style: appBar_Style,
                    ),
                    scrollable: true,
                    content: TextField(
                      autocorrect: true,
                      onChanged: (text) {
                        theList = text;
                      },
                    ),
                    actions: [
                      MaterialButton(
                        child: Text("pop"),
                        onPressed: () {
                          setState(() {
                            inputList.add(theList);
                            theList = "";
                            checkBoxList.add(false);
                            taskMaker();
                          });
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
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
    );
  }
}

 */