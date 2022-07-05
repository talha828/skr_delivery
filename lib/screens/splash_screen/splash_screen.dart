
import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/screens/getStartScreen/get_start_screen.dart';
import 'package:skr_delivery/screens/child_lock/security_screen.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import 'package:skr_delivery/screens/splash_screen/NoInternetConnectionPage.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import '../../ApiCode/online_database.dart';
import '../../model/user_model.dart';
import '../../ApiCode/online_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  bool _serviceEnabled = false;
  Future<FirebaseApp> _initialization;
  Location location = new Location();
  LocationData _locationData;
  AnimationController _controller;
  static const int _duration = 2;

  getVersion() async {
    Uri url = Uri.parse("https://erp.suqexpress.com/api/appversion/3");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data['data'] == "04072022") {
      checkIntetrnetConnectivtiy();
    } else {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO_REVERSED,
          animType: AnimType.BOTTOMSLIDE,
          title: "Up-date your app",
          desc:
          "New version is available on play store. Please update your app",
          btnOkText: "Update Now",
          btnCancelText: "Ok",
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          btnOkOnPress: () async {
            getVersion();
          }).show();
    }
  }
  checkUser()async {
    _controller = AnimationController(
      duration: Duration(seconds: _duration),
      vsync: this,
    );
    _controller.addListener(() async {
      if (_controller.value == 1) {
        WidgetsFlutterBinding.ensureInitialized();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        phoneNumber = prefs.getString('phoneno');
        phonepass = prefs.getString('password');
        print("phone no is" + phoneNumber.toString());
        print("password is" + phonepass.toString());
        print('check location' + _serviceEnabled.toString());
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          _serviceEnabled = await Permission.location.isGranted;
          print("location permission: " + _serviceEnabled.toString());
          if (!_serviceEnabled) {
            var locationPermission = await Permission.location.request();
            print("permission ${locationPermission}");

            if (locationPermission.isGranted) {
              bool temp = await location.serviceEnabled();
              if (!temp) {
                bool _locationService = await location.requestService();
                // location.hasPermission(locationPermission.);
                if (!_locationService) {
                  print('denied');
                  Fluttertoast.showToast(
                      msg: "Please turn on location",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  return;
                }
              } else {
                print("already enabled");
              }
            } else {
              print('denied');
              Fluttertoast.showToast(
                  msg: "Please give location permission",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return;
            }
          } else {
            if (phoneNumber != null && phonepass != null) {
              var response = await Auth.signIn2(phoneNumber, phonepass);
              if (response.statusCode == 200) {
                var data = jsonDecode(utf8.decode(response.bodyBytes));
                Provider.of<UserModel>(context, listen: false).userSignIn(data);
                Navigator.pushReplacement(
                    context, SwipeLeftAnimationRoute(widget: MainScreen()));
              } else {
                Fluttertoast.showToast(
                    msg:
                    "${response.statusCode.toString()}: Something Went Wrong",
                    toastLength: Toast.LENGTH_LONG);
              }
            } else {
              Navigator.pushReplacement(
                //context, SwipeLeftAnimationRoute(widget: OnboardScreen()));
                  context,
                  NoAnimationRoute(widget: GetStartedScreen()));
            }
          }
        } else {
          if (phoneNumber != null && phonepass != null) {
            var response = await Auth.signIn2(phoneNumber, phonepass);
            if (response.statusCode == 200) {
              var data = jsonDecode(utf8.decode(response.bodyBytes));
              Provider.of<UserModel>(context, listen: false).userSignIn(data);
              Navigator.pushReplacement(
                  context, SwipeLeftAnimationRoute(widget: SecurityScreen()));
            } else {
              print(response.body.toString());
              var data = jsonDecode(response.body)['results'][0]['A'];
              print(data);
              Fluttertoast.showToast(
                  msg: "$data", toastLength: Toast.LENGTH_LONG);
            }
          } else {
            Navigator.pushReplacement(
                context, NoAnimationRoute(widget: GetStartedScreen()));
          }
        }

        _locationData = await location.getLocation();
      }
    });
    _controller.forward();
  }

  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }
  checkIntetrnetConnectivtiy() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // print("internet is not cnnected"+connectivityResult.toString());
      checkUser();
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // print("internet is not cnnected"+connectivityResult.toString());
      checkUser();
      // I am connected to a wifi network.
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => NoInterNetConnection()));
      print("internet is not cnnected");
    }
  }
  initFirebase() async {
    _initialization = Firebase.initializeApp();
  }
  @override
  void initState() {
    super.initState();
    initFirebase();
    getVersion();
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
class SwipeLeftAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  final int milli;
  SwipeLeftAnimationRoute({this.widget, this.milli = 500})
      : super(
    transitionDuration: Duration(
      milliseconds: milli,
    ),
    pageBuilder: (context, anim1, anim2) => widget,
    transitionsBuilder: (context, anim1, anim2, child) {
      var begin = Offset(1, 0);
      var end = Offset(0, 0);
      var tween = Tween<Offset>(begin: begin, end: end);
      var offsetAnimation = anim1.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
class NoAnimationRoute extends PageRouteBuilder {
  final Widget widget;
  NoAnimationRoute({this.widget})
      : super(
    transitionDuration: Duration(seconds: 0),
    pageBuilder: (context, anim1, anim2) {
      return widget;
    },
  );
}