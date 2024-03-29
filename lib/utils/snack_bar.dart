// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void openSnackBar(context,snackMessage,color){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    action: SnackBarAction(
      label: "ok",
      textColor: Colors.white,
      onPressed: (){},
    ),
    content: Text(
    snackMessage,style: TextStyle(
    fontSize: 14,

  ),),),);
}