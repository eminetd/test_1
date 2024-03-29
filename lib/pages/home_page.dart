// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:navigation2_0/model/user_model.dart';
import 'package:navigation2_0/route/route.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
automaticallyImplyLeading: false,
        title: Text("${loggedInUser.email}"),
        actions: [
          IconButton(onPressed: (){
            logout(context);
          }, icon: Icon(Icons.logout),),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Center(child: Text("Welcome to the home page"))
                // Text(
                //   "${loggedInUser.firstName}"
                // ),
                //  Text(
                //   "${loggedInUser.secondName}"
                // )
              ],
            ),
          )
        ],
      ),
   );
  }
  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
        await googleSignIn.signOut();

    Navigator.pushNamed(context, Routes.logIn);
  }
}