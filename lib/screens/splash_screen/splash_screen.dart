
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/screens/getStartScreen/get_start_screen.dart';
import 'package:skr_delivery/screens/child_lock/security_screen.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import '../../ApiCode/online_database.dart';
import '../../model/user_model.dart';
import '../../ApiCode/online_auth.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checkUser()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoNo = prefs.getString('phoneno');
    String password = prefs.getString("password");
    phoneNumber=prefs.getString('phoneno');
    phonepass=prefs.getString('password');
    Location location = new Location();

    bool _serviceEnabled;
    LocationData _locationData;
    await Permission.location.request();
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled){
        return;
      }
    }
    else{
      if(_serviceEnabled){
        if (phoNo != null && password != null) {
          var response = await Auth.signIn2(phoNo, password);
          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            await Provider.of<UserModel>(context, listen: false).userSignIn(
                data);
            Timer(Duration(seconds:0), () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecurityScreen())));
          }
        }
        else{
          Timer(Duration(seconds: 0), () =>
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GetStartedScreen())));
        }
      }
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
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
