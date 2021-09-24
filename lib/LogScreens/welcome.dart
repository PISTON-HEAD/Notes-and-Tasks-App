import 'package:flutter/material.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome"),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body:SingleChildScrollView(
            child:Expanded(
              child: Column(
                children: [
                 Container(

                   child:  Text("""
 Welcome to Notes and Tasks Pro

Welcome and Indulge yourself in the professional environment with our new app. This is a real time data updating, cloud storage based 2 in 1 function professional usage oriented app which can maintain and store any number of your notes and tasks. Use it and feel the professionalism and user friendly nature of this multi feature app.

Special and Unique Features:

1. Tasks have a check box which is a feature unique to us, which when clicked shows the task as completed and the completion status gets updated.
2. Recently updated notes come in the top of the list to keep you up to date with the recent notes at the top.
3. Tasks have a real time data update to the cloud feature which enables the data to get saved even if the user forgets to click save while updating the task.
4. A search bar is provided in the notes section which helps in quick search of notes and to see topics of all the notes as a list.
5. The unique feature of Multiple device login with the same username and password is allowed in order to facilitate a group of people having works to complete share a same account so that if one user creates a note or task everybody can see it in their devices at the same time.
6. Notes have a special viewing feature in the display page which is unique to our app. When you swipe down on the note in the notes list page, you can see the full content of the note without going inside it itself.
7. In both notes and tasks, the date and  time of the last edit done is updated and displayed which is very unique to this app.
8. Notes have share option which is unique and very new to a notes app. You can share notes to anybody through any sharing application in your mobile. The format of the note is maintained irrespective of which app you choose to share it.
9. This app doesn't take any space from your device for saving data of your notes and tasks. It is saved in real time in the app's cloud storage base.
10. Signup is made easy and user friendly. Signup with app and a google signup option is also provided. Forgot password option is also provided which sends the user a mail with the link to reset your password, so your password is completely secure. 

Privacy Policy:
This app is developed with non-profitable and community betterment aim by independent developers who are not involved in any business organisation. So, we assure you with utmost confidence that your data is safe in the app's cloud storage and it will not be accessed or tampered in any case and for any motive. The user's account password is encrypted and nobody else can access it in case oo both app login and google login. 
The app does not ask for any type of personal details or device permissions from the user which is a uniqueness of this app. The only detail it asks for is the user's mail id which is needed to create an account for the user.
                     
                      """,style: TextStyle(
                     fontFamily: "Merriweather",
                     fontSize: 18,
                     color: Colors.white,
                   ),),
                 ),
                  MaterialButton(
                    color: Colors.greenAccent,
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn_Page()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: Center(
                        child: Text("I Agree",style: TextStyle(
                          fontFamily: "Merriweather",
                          fontWeight: FontWeight.w700,
                          fontSize: 22
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ), ),
      ),
    );
  }
}
