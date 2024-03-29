// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:navigation2_0/pages/home_page.dart';
import 'package:navigation2_0/pages/register.dart';
import 'package:navigation2_0/pages/splashscreen.dart';
import 'package:navigation2_0/provider/internet_provider.dart';
import 'package:navigation2_0/provider/sign_in.dart';
import 'package:navigation2_0/route/route.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectuser;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context)=>SignInProvider()),),
        ChangeNotifierProvider(create: ((context)=>InternetProvider()),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/spalshscreen",
        theme: ThemeData(
          primarySwatch:Colors.red,
        ),
        routes: <String ,WidgetBuilder>{
          Routes.splashScreeen:(BuildContext context)=>SplashScreeen(),
          Routes.logIn:(BuildContext context)=> LoginPage(),
          Routes.registerPage:(BuildContext context)=> RegisterPage(),
          Routes.homePage:(BuildContext context)=>HomePage(),
        },
      ),
    );
  }
}



// class UserDetailView extends StatelessWidget {
//   final String? user;
//   UserDetailView({Key? key,this.user}):super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("User Details"),),
//       body: Center(child: Text("Hello,$user"),),
//     );
//   }
// }