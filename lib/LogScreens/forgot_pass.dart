import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:to_do_list/widgets/customWidgets.dart';

class ForgotPassword extends StatefulWidget {

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  
  TextEditingController emailEditingController = new TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool reset = false;
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password",style:TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            fontFamily: "Cinzel",//"Pacifico",
            letterSpacing: 1,
            //decoration: TextDecoration.lineThrough,
            color: CupertinoColors.systemTeal,//Colors.tealAccent
          ),),
          centerTitle: true,
          elevation: 10,
          bottomOpacity: 5,
          backgroundColor: CupertinoColors.black,
        ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              reset?Text("Reset Password Link has been sent to the respected email"):SizedBox(),
              Container(
                decoration: BoxDecoration(
                    color: secondaryColor,
                    border: Border.all(color: Colors.blue)),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: textFieldStyle,
                  validator: (value){
                    if (RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return null;
                    } else {
                      return "Enter valid Email";
                    }
                  },
                  controller: emailEditingController,
                  decoration: textInputDecoration("Email", Icons.alternate_email_outlined),
                ),
              ),
              SizedBox(height: 15,),
              Text("A password reset link will be sent immediately to your email id, when you click on the reset link button.",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),),
              SizedBox(height: 15,),
              Container(
                height: MediaQuery.of(context).size.height/15,
                width: MediaQuery.of(context).size.width,
                child: MaterialButton(
                  color: Colors.greenAccent,
                    onPressed: (){
                 setState(() {
                   firebaseAuth.sendPasswordResetEmail(email: emailEditingController.text).whenComplete((){
                      reset=true;
                     Navigator.of(context).pop();
                   });
                 });
                }, child: Text("Send reset link",style:TextStyle(
                  color: Colors.white,
                  fontFamily: "Merriweather",
                  fontWeight: FontWeight.w900,
                  fontSize: 16.5,
                ),)),
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}
