import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/MyApp/NotesveriWer.dart';

class searchTitle extends SearchDelegate<String> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool oneTime = true;
  bool single = true;
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
  Widget buildResults(BuildContext context) {
    final result = query;
    bool contain = false;

    print(result);
    if (allTitles.contains(result) && single == true) {
      contain = true;
      single = false;
      print("Contains Title:$result");
      FirebaseFirestore.instance
          .collection("My Task")
          .doc(auth.currentUser.uid)
          .collection("Notes")
          .get()
          .then((value) {
        for (int i = 0; i < value.docs.length; i++) {
          if (result.toString() == value.docs[i]["Title"].toString()) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SeeNote(
                          getDoc: value.docs[i],
                        )));
          }
        }
      });
    } else {
      print("No result");
    }

    return contain
        ? Container()
        : Container(
            child: Center(
              child: Text(
                  "No results found!"
                  "",
                  style: TextStyle(color: Colors.black54, fontSize: 20)),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggester = query.isEmpty
        ? allTitles
        : allTitles.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggester.length,
        itemBuilder: (context, index) => ListTile(
              autofocus: true,
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
                    ]),
              ),
            ));
  }
}
