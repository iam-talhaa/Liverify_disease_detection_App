import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liverify_disease_detection/main.dart';
import 'package:liverify_disease_detection/screens/home_screen/Home_screen.dart';

class SplashServices {
  void Login(context) {
    Timer(Duration(seconds: 05), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Navigation_Bar()),
      );
    });
  }
}
