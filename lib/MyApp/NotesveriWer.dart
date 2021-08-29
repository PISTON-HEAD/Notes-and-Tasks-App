import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:to_do_list/MyApp/profile.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class SeeNote extends StatefulWidget {
  DocumentSnapshot getDoc;
  SeeNote({this.getDoc});

  @override
  _SeeNoteState createState() => _SeeNoteState();
}

class _SeeNoteState extends State<SeeNote> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController notesEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();

  TextStyle notesTitle(Color color, double size) {
    return TextStyle(
      color: color,
      fontSize: 24,
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  notesUpdater() {
    widget.getDoc.reference
        .delete();
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).collection("Notes").doc(DateTime.now().toString()).set({
      "Title":titleEditingController.text,
      "Content":notesEditingController.text,
      "Time":DateTime.now().toString(),
    }).whenComplete(() =>Navigator.of(context).pop());
  }
  String AmPm = "";
  timeChanger(){
    if(AmPm == "13"){AmPm = "01"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "14"){AmPm = "02"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "15"){AmPm = "03"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "16"){AmPm = "04"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "17"){AmPm = "05"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "18"){AmPm = "06"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "19"){AmPm = "07"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "20"){AmPm = "08"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "21"){AmPm = "09"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "22"){AmPm = "10"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "23"){AmPm = "11"+timeEditingController.text.toString().substring(13,16)+" PM";}else if(AmPm == "00"){AmPm = "12"+timeEditingController.text.toString().substring(13,16)+" AM";}else{
      AmPm = timeEditingController.text.toString().substring(11,16);
    }
    }

  @override
  void initState() {
    titleEditingController =
        TextEditingController(text: widget.getDoc["Title"]);
    notesEditingController =
        TextEditingController(text: widget.getDoc["Content"]);
    timeEditingController = TextEditingController(text: widget.getDoc["Time"]);
    AmPm = timeEditingController.text.toString().substring(11,13);
    timeChanger();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1,
        backgroundColor: Colors.blueGrey,
        title: Text(
          "Edited on: ${timeEditingController.text.toString().substring(8, 10)}${timeEditingController.text.toString().substring(4, 8)}${timeEditingController.text.toString().substring(0, 4)} $AmPm",
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
          child: Text(
            "Save",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          onPressed: () {
            if (formKey.currentState.validate() ) {
              if(titleEditingController.text != widget.getDoc["Title"] || notesEditingController.text != widget.getDoc["Content"]){
                print("Title Name: ${titleEditingController.text}");
                notesUpdater();
              }else{Navigator.of(context).pop();}
            }
          },
        ),

          PopupMenuButton(
            icon: Icon(Icons.more_vert_outlined),
            color: Colors.blueGrey,
            itemBuilder:(context)=>[
              PopupMenuItem(
                value: 0,
                child: MaterialButton(
                    onPressed: () {
                      showDialog(
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
                                      widget.getDoc.reference
                                          .delete()
                                          .whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => profile_Screen())));
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
                    },
                    child: Text("Delete",style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),),

                ),
              ),
              PopupMenuItem(
                child: MaterialButton(
                  onPressed: ()async{
                    await FlutterShare.share(
                      title: titleEditingController.text,
                      text: """
                        ${titleEditingController.text}
                        ${notesEditingController.text}
                              """,
                      chooserTitle:titleEditingController.text,).whenComplete(() =>{
                      Navigator.of(context).pop(),
                    });
                  },
                  child: Text("Share",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: TextFormField(
                    maxLines: 1,
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value.length == 0 && value.length < 25
                          ? "Enter a valid title"
                          : null;
                    },
                    controller: titleEditingController,
                    style: TextStyle(
                        fontFamily: "Merrieather",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24),
                    decoration: InputDecoration(
                        hintText: "Title",
                        hintStyle: notesTitle(Colors.grey, 24),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.cyanAccent,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                ),
                child: TextFormField(
                  controller: notesEditingController,
                  decoration: InputDecoration(
                    hintText: "Content",
                    hintStyle: notesTitle(Colors.white, 20),
                  ),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: customStyle(Colors.white, 20, FontWeight.w600, ""),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
