import 'dart:async';

import 'package:fb_login/screens/LogIn_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    login();
  }
  void login(){

    Timer(const Duration(seconds:3),(){
   Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const LogIn()));
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage('assets/splash.png'),
      fit:BoxFit.cover,
    );
  }
}
