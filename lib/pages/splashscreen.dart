// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigation2_0/pages/home_page.dart';
import 'package:navigation2_0/pages/login.dart';
import 'package:navigation2_0/provider/sign_in.dart';
// import 'package:navigation2_0/route/route.dart';
import 'package:navigation2_0/utils/next_screen.dart';
import 'package:provider/provider.dart';


class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {



   @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();
    Timer(const Duration(seconds:  5), () {
      sp.isSignedIn == false 
      ? nextScreen(context,LoginPage())
      : nextScreen(context,HomePage());
     });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome !!",style: TextStyle(
          fontSize: 30
        ),),
      ),
    );
  }
}