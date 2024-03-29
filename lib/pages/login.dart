// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, sort_child_properties_last, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:navigation2_0/pages/home_page.dart';
import 'package:navigation2_0/provider/internet_provider.dart';
import 'package:navigation2_0/provider/sign_in.dart';
// import 'package:navigation2_0/provider/sign_in.dart';
import 'package:navigation2_0/route/route.dart';
import 'package:navigation2_0/utils/next_screen.dart';
import 'package:navigation2_0/utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:provider/provider.dart';
// import 'package:navigation2_0/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RoundedLoadingButtonController googlecontroller =
      RoundedLoadingButtonController();

  // firebase Auth
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  bool _areFieldsValid() {
    return _formKey.currentState != null&& emailController.text.isNotEmpty && passwordController.text.isNotEmpty && _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
       validator: (value) {
      if (value!.isEmpty) {
        return null; // Return null if value is empty
      }
      // reg expression for email validation
      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
          .hasMatch(value)) {
        return "Please Enter a valid email";
      }
      return null;
    },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
      if (value!.isEmpty) {
        return null; // Return null if value is empty
      }
      RegExp regex = RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*()_+{}\[\]:;<>,.?/~]).{8,}$');
      if (!regex.hasMatch(value)) {
        return "Enter Valid Password(Min. 8 Character)";
      }
      return null;
    },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: _areFieldsValid() ? Colors.redAccent : Colors.grey,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: _areFieldsValid()
              ? () {
                  signIn(emailController.text, passwordController.text);
                }
              : null,
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 35),
                    loginButton,
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.registerPage);
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    RoundedLoadingButton(
                      controller: googlecontroller,
                      onPressed: () {
                        handlegoogleSignIn();
                      },
                      width: MediaQuery.of(context).size.width * 0.7,
                      elevation: 0,
                      borderRadius: 25,
                      child: Wrap(
                        children: const [
                          Icon(
                            FontAwesomeIcons.google,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      color: Colors.red,
                      successColor: Colors.red,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.pushReplacementNamed(context, Routes.homePage),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

//handle google sign in
  Future handlegoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    //internet provider
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackBar(context, "check your Internet connection", Colors.red);
      googlecontroller.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.erroCode.toString(), Colors.red);
          googlecontroller.reset();
        } else {
          //checking whether user exist or not
          sp.checkUserExist().then((value) async {
            if (value == true) {
              ///user exist
              Navigator.pushNamed(context, Routes.homePage);
            } else {
              //user doesn't exist
              sp.saveDatatoFirestore().then((value) => sp
                  .saveDataToSharedPreference()
                  .then((value) => sp.setSignIn().then((value) {
                        googlecontroller.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

//handle after sign in

  handleAfterSignIn() async {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomePage());
    });
  }
}
