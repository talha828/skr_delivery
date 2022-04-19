import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skr_delivery/splash_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.red));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skr App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      //home: NoInterNetConnection(),
      home: SplashScreen(),
      // home:AgingScreen()
      //home: MainMenuScreen(),
    );
  }
}
