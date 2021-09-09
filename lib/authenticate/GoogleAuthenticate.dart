import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/authenticate/firebaseAuth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignIn signIn = GoogleSignIn();
Future signInWithGoogle()async{
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    GoogleSignInAccount account = await signIn.signIn();
    GoogleSignInAuthentication authentication = await account.authentication;
    AuthCredential credential = await GoogleAuthProvider.credential(idToken: authentication.idToken,accessToken: authentication.accessToken);
    final googleId = (await firebaseAuth.signInWithCredential(credential)).user;
    print("This is google id $googleId");
    final logger = (await FirebaseFirestore.instance.collection("Google Users").where("id",isEqualTo: googleId.uid).get()).docs;
    if(logger.length == 0){
      print("New User -- Initializing Cloud \n");
      FirebaseFirestore.instance.collection("Google Users").doc(googleId.uid).set({
        "Name":googleId.displayName,
        "Email":googleId.email,
        "Photo Url":googleId.photoURL,
        "Phone No.":googleId.phoneNumber,
        "Created Time":DateTime.now().microsecondsSinceEpoch,
        "Last SignedIn":DateTime.now().toString().toString().substring(0,16),
        "id":googleId.uid,
      });
      FirebaseFirestore.instance.collection("My Task").doc(googleId.uid).set({
        "Task List":[],
        "Checker":[],
        "Time Stamp":[],
        "Count":count,
      });
      FirebaseDatabase database = FirebaseDatabase.instance;
      database.reference().child(googleId.uid).set({
        "Task List":[],
        "CheckBox List":[],
        "Time Stamp":[],
        "Count":count,
      });
      print("Shared Prefrences are being realized \n");
      sharedPreferences.setString("id",googleId.uid);
      sharedPreferences.setString("Name",googleId.displayName);
      sharedPreferences.setString("Email",googleId.email);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(error){
    print("This is the error Here: $error");
    if(error.toString().length > 5){
      return error;
    }else{
      return null;
    }
}
}