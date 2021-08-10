import 'package:flutter/material.dart';
import 'package:to_do_list/LogScreens/SignIn_Screen.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Terms and Conditions"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Column(
                children: [
                  Text("Design the button"),
                  MaterialButton(
                      child: Text("I Agree"),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignIn_Page()));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
