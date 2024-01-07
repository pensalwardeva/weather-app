import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget CustomButton(String buttonTitle,double height, {required Null Function() onPressed}) {

  return MaterialButton(
      onPressed: () {
        onPressed ();
      },
      child: Container(
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blue, Colors.blue])),
          child: Center(
            child: Text(
              buttonTitle,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          )));
}