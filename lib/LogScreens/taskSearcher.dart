import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class taskSearch extends SearchDelegate{

  FirebaseAuth auth = FirebaseAuth.instance;
  var taskList = [];
  bool onetime = true;
  getAllTask(){
    FirebaseFirestore.instance.collection("My Task").doc(auth.currentUser.uid).get().then((value) {
    if(value["Task List"].lenght>0 && onetime == true){
      onetime = false;
      taskList = value["Task List"];
    }else{}
    });
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    getAllTask();
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestion = query.isEmpty ?taskList:taskList.where((element) => element.startsWith(query)).toList();
  }
}