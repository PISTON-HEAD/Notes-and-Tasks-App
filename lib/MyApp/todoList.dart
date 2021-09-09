import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';
import 'package:to_do_list/MyApp/aboutTheApp.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class todoListCreation extends StatefulWidget {
  final getterList;
  final checkBoxValue;
  final Id;

  const todoListCreation(
      {Key key, this.getterList, this.checkBoxValue, this.Id})
      : super(key: key);
  @override
  _todoListCreationState createState() =>
      _todoListCreationState(getterList, checkBoxValue, Id);
}

class _todoListCreationState extends State<todoListCreation> {
  final Id;
  _todoListCreationState(getterList, checkBoxValue, this.Id);

  List taskList = [];
  TextEditingController taskController = new TextEditingController();
  String taskAdder = "";
  List checkBoxList = [];
  List timeStampList = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  int count = 0;
  bool deleteOnce = true;



  @override
  void initState() {
    getAll();
    // TODO: implement initState
    super.initState();
  }

  getAll() {
    FirebaseDatabase.instance
        .reference()
        .child(auth.currentUser.uid)
        .once()
        .then((data) {
      taskList = [];
      checkBoxList = [];
      timeStampList = [];
      print("Database at get all");
      print(data.value["Task List"]);
      if (data.value["Count"] == 0) {
        print("Init Count == 0");
      } else {
        for (int i = 0; i < data.value["Count"]; i++) {
          taskList.add(data.value["Task List"][i]);
          checkBoxList.add(data.value["CheckBox List"][i]);
          timeStampList.add(data.value["TimeStamp List"][i]);
        }
      }
    });
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
                  GoogleSignIn signIn = GoogleSignIn();
                  print("Log Out");
                  User user = auth.currentUser;
                  print("Provider Info:${user.providerData[0].toString()} ");
                  if(auth.currentUser.providerData[0].providerId == "google.com"){
                    print("Google Sign-OUT");
                    await signIn.disconnect();
                    await signIn.signOut();
                  }else{
                    await auth.signOut();
                  }
                  SharedPreferences shared =
                  await SharedPreferences.getInstance();
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/originals/4f/6d/05/4f6d052bb1b26150115888ea06d4c106.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder(
              stream: FirebaseDatabase.instance
                  .reference()
                  .child(auth.currentUser.uid)
                  .orderByChild("Time Stamp")
                  .onValue,
              builder: (context, snapshot) {
                return snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.snapshot.value["Task List"] != null
                    ? ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: snapshot.data.snapshot.value["Count"],
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://wallpapercave.com/wp/wp5056723.jpg"),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: Colors.cyanAccent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                  side: BorderSide(
                                    color: Colors.white,
                                  ),
                                  autofocus: true,
                                  activeColor: Colors.cyanAccent,
                                  splashRadius: 20,
                                  value: snapshot.data.snapshot
                                      .value["CheckBox List"][index],
                                  onChanged: (value) {
                                    checkBoxList = snapshot
                                        .data.snapshot.value["CheckBox List"];
                                    if (checkBoxList[index] == false) {
                                      checkBoxList[index] = true;
                                    } else {
                                      checkBoxList[index] = false;
                                    }
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child(auth.currentUser.uid)
                                        .update({
                                      "CheckBox List": checkBoxList,
                                    });
                                  }),
                              title: Text(
                                "${index+1}) ${snapshot.data.snapshot.value["Task List"][index]}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Merriweather",
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  DeleteTask(context, snapshot, index);
                                },
                                icon: Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                              onLongPress: (){
                                DeleteTask(context, snapshot, index);
                              },
                              onTap: () {
                                getAll();
                                taskController = TextEditingController(
                                    text: snapshot.data.snapshot
                                        .value["Task List"][index]);
                                taskEditor(context, snapshot, index);
                              },
                            ),
                          );
                        },
                      )
                    : Container();
              }),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyanAccent,
          highlightElevation: 15,
          autofocus: true,
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.black,
            size: 23,
          ),
          onPressed: () {
            taskController.text="";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text(
                      "Add New Task",
                      style: TextStyle(
                        fontFamily: "Acme",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: TextFormField(
                      onChanged: (value){
                        print(value);
                      },
                      autofocus: true,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      controller: taskController,
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Merriweather",
                          ),
                        ),
                        onPressed: () {
                          if(taskController.text != ""){
                            FirebaseDatabase.instance
                              .reference()
                              .child(auth.currentUser.uid)
                              .once()
                              .then((data) {
                            taskList = [];
                            checkBoxList = [];
                            timeStampList = [];
                            print("Database at get all");
                            print(data.value["Task List"]);
                            if (data.value["Count"] == 0) {
                              print("Init Count == 0");
                            } else {
                              for (int i = 0; i < data.value["Count"]; i++) {
                                taskList.add(data.value["Task List"][i]);
                                checkBoxList
                                    .add(data.value["CheckBox List"][i]);
                                timeStampList
                                    .add(data.value["TimeStamp List"][i]);
                              }
                            }
                          }).whenComplete(() {
                            print("This taskList at save get All \n $taskList");
                            taskList.add(taskController.text);
                            checkBoxList.add(false);
                            timeStampList.add(DateTime.now().toString());
                            count = taskList.length;
                            print("Task List ==> $taskList");
                            print("CheckBox List ==> $checkBoxList");
                            print("Time Stamp List ==> $timeStampList");
                            print("Count ==> $count");
                            taskController.text = "";
                            FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).set(
                                {
                                  "Task List":taskList,
                                  "Count":taskList.length,
                                  "Checker":checkBoxList,
                                  "Time Stamp":timeStampList,
                                });
                            FirebaseDatabase.instance
                                .reference()
                                .child(auth.currentUser.uid)
                                .set({
                              "Count": count,
                              "Task List": taskList,
                              "CheckBox List": checkBoxList,
                              "TimeStamp List": timeStampList,
                            }).whenComplete(() => Navigator.of(context).pop());
                          });}else{
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  Future<dynamic> DeleteTask(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return showDialog(context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    scrollable: true,
                                    title: Text("Delete Task",style:TextStyle(
                                      fontFamily: "Acme",
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    content: CompletionStatus(snapshot, index),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                              child: Text("Delete",style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),),
                                              onPressed: (){
                                                print("The delete: $deleteOnce");
                                                if(deleteOnce == true){
                                                  deleteOnce =  false;
                                                  taskList = [];
                                                  checkBoxList = [];
                                                  timeStampList = [];
                                                  for (int i = 0;
                                                  i <
                                                      snapshot.data.snapshot
                                                          .value["Task List"].length;
                                                  i++) {
                                                    if (i != index) {
                                                      taskList.add(snapshot
                                                          .data.snapshot.value["Task List"][i]);
                                                      checkBoxList.add(snapshot.data.snapshot
                                                          .value["CheckBox List"][i]);
                                                      timeStampList.add(snapshot.data.snapshot
                                                          .value["TimeStamp List"][i]);
                                                    }
                                                  }
                                                  // FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).set(
                                                  //     {
                                                  //       "Task List":taskList,
                                                  //       "Count":taskList.length,
                                                  //       "Checker":checkBoxList,
                                                  //       "Time Stamp":timeStampList,
                                                  //     });
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child(auth.currentUser.uid)
                                                      .update({
                                                    "Task List": taskList,
                                                    "TimeStamp List": timeStampList,
                                                    "CheckBox List": checkBoxList,
                                                    "Count": taskList.length,
                                                  }).whenComplete((){
                                                    deleteOnce = true;
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: TextButton(
                                              child: Text("Cancel",style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                              ),),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                });
  }

  RichText CompletionStatus(AsyncSnapshot<dynamic> snapshot, int index) {
    return RichText(
                                    text: TextSpan(text: "Completion Status: ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Merriweather",
                                        color: Colors.black,
                                      ),
                                      children:[
                                        TextSpan(
                                          text: snapshot.data.snapshot.value["CheckBox List"][index] ? "Completed" : "Not Completed",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: snapshot.data.snapshot.value["CheckBox List"][index] ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
  }

  Future<dynamic> taskEditor(BuildContext context, AsyncSnapshot<dynamic> snapshot, int index) {
    return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String q = snapshot.data.snapshot
                                        .value["Task List"][index];
                                    String AmPm = snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(11,13);
                                    if(AmPm == "13"){AmPm = "01"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "14"){AmPm = "02"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "15"){AmPm = "03"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "16"){AmPm = "04"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "17"){AmPm = "05"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "18"){AmPm = "06"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "19"){AmPm = "07"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "20"){AmPm = "08"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "21"){AmPm = "09"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "22"){AmPm = "10"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "23"){AmPm = "11"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else if(AmPm == "24"){AmPm = "12"+snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(13,16) + " PM";}else{
                                      AmPm = snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(11,16);
                                    }
                                      return AlertDialog(
                                      scrollable: true,
                                      title: Text(
                                        "Edit Task",
                                        style: TextStyle(
                                          fontFamily: "Acme",
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        children: [
                                          TextFormField(
                                            onChanged:(value){
                                              // print( "This real time ${taskController.text}");
                                              if(taskController.text != "" && taskController.text != snapshot.data.snapshot.value["Task List"][index]){
                                                taskList[index] = taskController.text;
                                                // print("This is taskList at edited area ==> $taskList");
                                                timeStampList[index] = DateTime.now().toString();
                                                FirebaseDatabase.instance.reference().child(auth.currentUser.uid).update(
                                                    {
                                                      "Task List":taskList,
                                                      "TimeStamp List":timeStampList,
                                                    });
                                              }else if(taskController.text == ""){
                                                taskList[index] = q;
                                                // print("This is taskList at edited area ==> $taskList");
                                                timeStampList[index] = DateTime.now().toString();
                                                FirebaseDatabase.instance.reference().child(auth.currentUser.uid).update(
                                                    {
                                                      "Task List":taskList,
                                                      "TimeStamp List":timeStampList,
                                                    });
                                              }

                                            },
                                            autofocus: true,
                                            maxLines: null,
                                            textInputAction:
                                                TextInputAction.newline,
                                            keyboardType: TextInputType.multiline,
                                            controller: taskController,
                                          ),
                                          SizedBox(height:15),
                                          CompletionStatus(snapshot, index),
                                        ],
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("""Edited On:
${snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(8,10)}${snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(4,7)}-${snapshot.data.snapshot.value["TimeStamp List"][index].toString().substring(2,4) }  $AmPm""",
                                            style:TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Cinzel"),
                                    ),
                                            MaterialButton(
                                              color: Colors.cyanAccent,
                                              child: Text(
                                                "Save",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Merriweather",
                                                ),
                                              ),
                                              onPressed: (){
                                                //not needed mostly so commented as onChanged is more good and save iss just extra
                                                // if(taskController.text != "" && taskController.text != snapshot.data.snapshot.value["Task List"][index]){
                                                //   taskList[index] = taskController.text;
                                                //   print("This is taskList at edited area ==> $taskList");
                                                //   timeStampList[index] = DateTime.now().toString();
                                                //   taskController.text = "";
                                                //   FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).set(
                                                //       {
                                                //         "Task List":taskList,
                                                //         "Count":taskList.length,
                                                //         "Checker":checkBoxList,
                                                //         "Time Stamp":timeStampList,
                                                //       });
                                                //   FirebaseDatabase.instance.reference().child(auth.currentUser.uid).update(
                                                //       {
                                                //         "Task List":taskList,
                                                //         "TimeStamp List":timeStampList,
                                                //       }).whenComplete(() => Navigator.of(context).pop());
                                                // }else if(taskController.text == ""){
                                                //   taskList[index] = q;
                                                //   // print("This is taskList at edited area ==> $taskList");
                                                //   timeStampList[index] = DateTime.now().toString();
                                                //   FirebaseDatabase.instance.reference().child(auth.currentUser.uid).update(
                                                //       {
                                                //         "Task List":taskList,
                                                //         "TimeStamp List":timeStampList,
                                                //       }).whenComplete(() => Navigator.of(context).pop(),);
                                                // }else{
                                                //   Navigator.of(context).pop();
                                                // }
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