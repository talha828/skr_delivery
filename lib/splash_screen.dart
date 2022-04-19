import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:skr_delivery/screens/getStartScreen/get_start_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>GetStartedScreen())));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(child: Image.asset("assets/logo.png", scale: 2)),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("SKR Service 2021. All Right Reserved.",style: TextStyle(color: themeColor1,fontSize: 14),)
          ),
        ],
      ),
    );
  }
}
