import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppInfo extends StatefulWidget {
  final value;
  const AppInfo({Key key, this.value}) : super(key: key);

  @override
  _AppInfoState createState() => _AppInfoState(this.value);
}

class _AppInfoState extends State<AppInfo> {
  final value;
  _AppInfoState(this.value);
  var appInformation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            value == 0
                ? "About App"
                : value == 1
                    ? "About Developers"
                    : value == 2
                        ? "Privacy Policy"
                        : "",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: "Cinzel", //"Pacifico",
              color: Colors.white, //Colors.tealAccent
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.cyanAccent,
                    width: 3,
                  )),
              child: SingleChildScrollView(
                child: Text(
                  value == 0
                      ? """This is a fully developed Notes and tasks app with cloud storage. 
Developed with flutter software. 
Compatible with android and ios as well.

The notes and tasks you create will not occupy space in your device and it will automatically be saved and updated in the app's cloud storage space. So, feel free to create and edit as much notes and tasks as you want as it wont occupy space in your device.

As this app has the feature to link all notes and tasks of the user to their account, you can use this app in multiple devices and you can access all your notes and tasks in all devices.

There is a signup option with the app.
If you forget the password to your account, we have a sophisticated and secured procedure in the forgot password option to send you an email with the link to the new password.

User can edit any note or task any number of times and the timestamp will show the date and time of the latest edit.

In the tasks section, user can mark a task as completed by clicking the check box.

User can also search the notes with their titles using the search bar.

We sincerely hope that you will like the easy to use user interface of the app and if you do, then please share our app among your friends and support it by giving 5 stars and comments. It will prove to be a tremendous motivation for our future projects.



"""
                      : value == 1
                          ? """
                          
We are B.Tech students of Amrita Vishwa Vishya Peetham University, Coimbature, Tamil Nadu, India. We are very much interested in app, web and software development and this is one of our projects. 

Being passionate young developers, our sole aim is to make the daily life of the mobile users community a bit more easier with this 2 in 1 app which can maintain your notes and tasks in one place, and store it in the cloud. 

We are keen and are looking forward to improvising the app further in future updates and create more useful apps for our community.

C.K. Gokul Krishna
gokulkrishna1282@gmail.com
       and
A. Siva Kailash
sivakailashtech@gmail.com
"""
                          : value == 2
                              ? """
                              
The only personal information acquired by the app is the user's mail id. It is required to create an account for the user. Its DOES NOT ask for your name or date of birth or mobile number or any permission to access information from your mobile like other apps. 

This app is developed entirely from an app development learning perspective. There is NO business or profitable idea involved. The developers of this app do not belong to any company or organisation, they are independent learners learning app development. Therefore, the user's notes and tasks which are stored in the app's cloud storage are in safe hands and it is assured that nobody will access the user's notes and tasks. 

No advanced encryption algorithm is used to encrypt the data, as this is a independent learner's app and no business or profit is involved.

The user's password is secured and is not accessible by anybody, not even the developers. Even the forgot password option undergoes a secure procedure so that only the user can access it and not the developers.

    
    
                              """
                              : "",
                  style: TextStyle(
                    fontFamily: "Merriweather",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
