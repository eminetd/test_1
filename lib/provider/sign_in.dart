// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier{

bool _isSignedIn =  false;
bool get isSignedIn=>_isSignedIn;

//instance of firebaseauth

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();



//haserror,errorcode,provider,errorMessage,uid,email,name ,imageurl,

  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorCode;
  String? get erroCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;


  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  SignInProvider(){
    checkSignInUser();
  }

  Future checkSignInUser()async{
    final SharedPreferences s =  await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("signed_in") ?? false;
    notifyListeners();
  }


  Future setSignIn()async{
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("sigtn_in", true);
    _isSignedIn = true;
    notifyListeners();
  }

//sign in with google

Future signInWithGoogle()async{
final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

if(googleSignInAccount != null){
  //execute authentication
  try{
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,

    );
    //signing to firebase user instance
    final User userDetails = (await firebaseAuth.signInWithCredential(credential)).user!;


    // save all values
    _name = userDetails.displayName;
    _email = userDetails.email;
    _imageUrl = userDetails.photoURL;
    _provider = "Google";
    _uid = userDetails.uid;
    notifyListeners();
  } on FirebaseAuthException catch(e){
    switch(e.code){
      case "account-exist-with-diffrent-credential":
      _errorCode = "You already have account";
      _hasError = true;
      notifyListeners();
      break;

      case "null": 
      _errorCode = "Some unexpected error while trying to sign in";
      _hasError = true;
      notifyListeners();
      break;
      default:
      _errorCode = e.toString();
      _hasError= true;
      notifyListeners();

     }
   }
 } else {
  _hasError = true;
  notifyListeners();
  }
 }




  Future getUserDataFromFirestore()async{
   await FirebaseFirestore.instance
   .collection("users")
   .doc(uid)
   .get()
   .then((DocumentSnapshot snapshot) => {
    _uid = snapshot["uid"],
    _name = snapshot["name"],
    _email = snapshot["email"],
    _imageUrl = snapshot["imageUrl"],
    _provider = snapshot['provider'],
   });
  }

  Future saveDatatoFirestore()async{
    final DocumentReference r = FirebaseFirestore.instance.collection("users").doc(uid);
    await r.set({
      "name":_name,
      "email":_email,
      "uid":_uid,
      "imageUrl":_imageUrl,
      "provider":_provider,

    });
    notifyListeners();
  }

  Future saveDataToSharedPreference()async{
    final SharedPreferences s=await SharedPreferences.getInstance();
    await s.setString('name', _name!);
    await s.setString('email', _email!);
    await s.setString('uid', _uid!);
    await s.setString('image_Url', _imageUrl!);
    await s.setString('provider', _provider!);
    notifyListeners();
  }

  //checkuser exist or not in Cloudfirestore
   Future<bool> checkUserExist()async{
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(_uid).get();
      if(snap.exists){
        print("existing user");
        return true;
      }
      else{
        print("New User");
        return false;
      }
   }


  Future userSignOut()async{
    firebaseAuth.signOut;
    await googleSignIn.signOut();
    _isSignedIn = false;
    notifyListeners();
    //clear all storage info
    clearStoreddata();

  }

  Future clearStoreddata()async{
    final SharedPreferences s= await SharedPreferences.getInstance();
    s.clear();
  }
}