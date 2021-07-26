import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    widget.getDoc.reference.update({
      "Title": titleEditingController.text,
      "Content": notesEditingController.text,
      "Time": DateTime.now().toString(),
    }).whenComplete(() => Navigator.of(context).pop());
  }

  @override
  void initState() {
    titleEditingController =
        TextEditingController(text: widget.getDoc["Title"]);
    notesEditingController =
        TextEditingController(text: widget.getDoc["Content"]);
    timeEditingController = TextEditingController(text: widget.getDoc["Time"]);
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
          "Edited on: ${timeEditingController.text.toString().substring(0, 16)}",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
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
              icon: Icon(
                FontAwesomeIcons.trash,
                size: 18,
              )),
          TextButton(
            child: Text(
              "Save",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            onPressed: () {
              if (formKey.currentState.validate()) {
                print("Title Name: ${titleEditingController.text}");
                notesUpdater();
              }
            },
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
                            color: Colors.black,
                            width: 3.5,
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
