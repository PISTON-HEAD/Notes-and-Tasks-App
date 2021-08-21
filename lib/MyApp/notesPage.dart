import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/widgets/customWidgets.dart';

class NotesScreen extends StatefulWidget {

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController notesEditingController = TextEditingController();


  TextStyle notesTitle(Color color , double size){
    return TextStyle(
    color: color,
    fontSize: 24,
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;
uploader()async{
  FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).collection("Notes").add(
      {
        "Title":titleEditingController.text,
        "Content":notesEditingController.text,
        "Time":DateTime.now().toString(),
      }).whenComplete(() => Navigator.of(context).pop());


}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          TextButton(
            child: Text("Save",style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),),
            onPressed: (){
            if(formKey.currentState.validate()){
              print("Title Name: ${titleEditingController.text}");
              uploader();
            }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyanAccent,width: 2),
                  ),
                  child: TextFormField(
                    autocorrect: true,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      return value.length==0?"Enter a title":null;
                    },
                    controller:titleEditingController,
                    style: TextStyle(
                        fontFamily: "Merrieather",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 24),
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: notesTitle(Colors.grey, 24),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:BorderSide(color: Colors.cyanAccent,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      )
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent
                      ,width: 2),
                ),
                child: TextFormField(
                  controller: notesEditingController,
                  decoration: InputDecoration(
                    hintText: "Content",
                    hintStyle: notesTitle(Colors.white70, 20),
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