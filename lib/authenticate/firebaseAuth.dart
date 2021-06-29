
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future signUp(String email , String password , String userName)async{
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    //the below variable has the email and password credentials
    final fireUser = credential.user;
    //an if condition can be kept to just in case if fireUser is empty??
    final logger = (await FirebaseFirestore.instance.collection("Ordinary_Users").where("id",isEqualTo: fireUser.uid).get()).docs;
    if(logger.length==0){
      print("New User -- Initializing Cloud Collection....");
      fireUser.updateDisplayName(userName);
      fireUser.updatePhotoURL(fireUser.photoURL);
      FirebaseFirestore.instance.collection("Ordinary_Users").doc(fireUser.uid).set({
        "Name":userName,
        "Email":email,
        "Password":password,
        "Recipes":0,
        "Profile Photo":firebaseAuth.currentUser.photoURL,
        "Created Time":DateTime.now().microsecondsSinceEpoch,
        "Last SignedIn":DateTime.now().toString().toString().substring(0,16),
        "id":fireUser.uid,
      });
      sharedPreferences.setString("id",fireUser.uid);
      sharedPreferences.setString("Name",userName);
      sharedPreferences.setString("Email",email);
      sharedPreferences.setString("Password",password);
      sharedPreferences.setString("Profile Photo",fireUser.photoURL);
      sharedPreferences.setInt("Recipes", 0);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(error){
  print("error found: $error");
  if(error.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account."){
    print("true");
    return error.toString();
  }else{
    return null;
  }
  }
}

Future logInUser(String email ,String password)async{
  try{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("Ordinary_Users").where("id",isEqualTo: fireUser.uid).get()).docs;
    if(logger.isNotEmpty){
      print("Old User Signing...");
      sharedPreferences.setString("id",logger[0]["id"]);
      sharedPreferences.setString("Name",logger[0]["Name"]);
      sharedPreferences.setString("Email",logger[0]["Email"]);
      sharedPreferences.setString("Password",logger[0]["Password"]);
      sharedPreferences.setString("Profile Photo",logger[0]["Profile Photo"]);
      sharedPreferences.setInt("Recipes", logger[0]["Recipes"]);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(e){
    print("this is error $e");
    if(e.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password." || e.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
      print("true");
      return e.toString();
    }else{
      return null;
    }
  }
}