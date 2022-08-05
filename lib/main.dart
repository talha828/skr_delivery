import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/model/customerList.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/trmpFile.dart';

import 'model/cart_model.dart';
import 'model/retrun_cart_model.dart';
import 'model/user_model.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.red));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (_) => UserModel(),
        ),
        ChangeNotifierProvider<CartModel>(
          create: (_) => CartModel(),
        ),
        ChangeNotifierProvider<RetrunCartModel>(create: (_) => RetrunCartModel()),
        ChangeNotifierProvider<CustomerList>(
          create: (_) => CustomerList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Skr App',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashScreen(),
        //home: NoInterNetConnection(),
        // home: Temp(),
        // home:AgingScreen()
        //home: MainMenuScreen(),
      ),
    );
  }
}
