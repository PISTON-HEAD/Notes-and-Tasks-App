import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/MyApp/NotesveriWer.dart';

class searchTitle extends SearchDelegate<String> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool oneTime = true;
  List allTitles = [];
  getTitles() async {
    FirebaseFirestore.instance
        .collection("My Task")
        .doc(auth.currentUser.uid)
        .collection("Notes")
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
      } else {
        if (oneTime) {
          oneTime = !true;
          for (int i = 0; i < value.docs.length; i++) {
            print(value.docs[i]["Title"]);
            allTitles.insert(i, value.docs[i]["Title"]);
          }
        }
      }
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
    getTitles();
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
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggester = query.isEmpty
        ? allTitles
        : allTitles.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggester.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("My Task")
                    .doc(auth.currentUser.uid)
                    .collection("Notes")
                    .get()
                    .then((value) {
                  for (int i = 0; i < value.docs.length; i++) {
                    if (suggester[index].toString() ==
                        value.docs[i]["Title"].toString()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeeNote(
                                    getDoc: value.docs[i],
                                  )));
                    }
                  }
                });
              },
              title: RichText(
                text: TextSpan(
                    text:
                        suggester[index].toString().substring(0, query.length),
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                          text: suggester[index]
                              .toString()
                              .substring(query.length),
                          style: TextStyle(
                            color: Colors.black54,
                          )),
                    ]
                ),
              ),
            ));
  }
}


/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/MyApp/NotesveriWer.dart';

class searchTitle extends SearchDelegate<String>{
FirebaseAuth auth = FirebaseAuth.instance;
bool oneTime = true;
List allTitles = [];
getTitles()async{
  FirebaseFirestore.instance
      .collection("My Task")
      .doc(auth.currentUser.uid)
      .collection("Notes").get().then((value){
        if(value.docs.isEmpty){}else{
          if(oneTime){
            oneTime =!true;
            for(int i=0; i<value.docs.length;i++){
                  print(value.docs[i]["Title"]);
                  allTitles.insert(i, value.docs[i]["Title"]);
            }
          }
        }
  });
}
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query ="";
      }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    getTitles();
    return IconButton(
      onPressed: (){
        close(context, null );
      },
      icon:AnimatedIcon(icon: AnimatedIcons.menu_arrow,
        progress:transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggester = query.isEmpty ?allTitles: allTitles.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggester.length,
        itemBuilder: (context,index)=>ListTile(
          onTap: (){
            FirebaseFirestore.instance
                .collection("My Task")
                .doc(auth.currentUser.uid)
                .collection("Notes").get().then((value){
                  for(int i = 0; i<value.docs.length;i++){
                    if(suggester[index].toString() == value.docs[i]["Title"].toString()){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SeeNote(getDoc: value.docs[i],)));
                    }
                  }
            });
          },
        title: RichText(text: TextSpan(
          text: suggester[index].toString().substring(0,query.length),
          style: TextStyle(
            color: CupertinoColors.black,fontWeight: FontWeight.w900,fontSize: 18,
          ),
          children: [
            TextSpan(
                text: suggester[index].toString().substring(query.length),
                style: TextStyle(
                  color: Colors.black54,
                )
            ),
          ]
      ),),
    ));

  }

}
 */
