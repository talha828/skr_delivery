import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/locationServices/broadcast.dart';
import 'package:skr_delivery/locationServices/location_callback_handler.dart';
import 'package:skr_delivery/locationServices/location_service_repository.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/screens/loginScreen/phonenumber/phonenumber.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'all_shop.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userCellNumber;
  String userName;
  // Timer _timer;
  // Stopwatch watch = Stopwatch();
  // String logStr = '';
  // LocationDto lastLocation;
  // bool isRunning;
  // bool isLoading = false;
  // bool _serviceEnabled = false;
  // bool isLoading2;
  // bool startsearching;
  // String elapsedTime = '';
  // bool startStop = true;
  // bool _isSearching;
  // loc.Location location = new loc.Location();
  // String sessionLogoutTime = '59:00';
  //
  // Timer locationTimer;
  // Timer reloadTimer;
  // ReceivePort port = ReceivePort();
  //
  // Future<void> updateUI(LocationDto data) async {
  //   final log = await FileManager.readLogFile();
  //
  //   //await _updateNotificationText(data);
  //
  //   setState(() {
  //     if (data != null) {
  //       lastLocation = data;
  //     }
  //     logStr = log;
  //   });
  // }
  // Future<void> initPlatformState() async {
  //   print('Initializing...');
  //   await BackgroundLocator.initialize();
  //   //logStr = await FileManager.readLogFile();
  //   print('Initialization done');
  //   final _isRunning = await BackgroundLocator.isServiceRunning();
  //   if(!_isRunning){
  //     _onStart();
  //   }
  //   _onStart();
  //   setState(() {
  //     isRunning = _isRunning;
  //   });
  //   print('Running ${isRunning.toString()}');
  // }
  // void _onStart() async {
  //   if (await _checkLocationPermission()) {
  //     await _startLocator();
  //     final _isRunning = await BackgroundLocator.isServiceRunning();
  //
  //     setState(() {
  //       isRunning = _isRunning;
  //       lastLocation = null;
  //     });
  //   } else {
  //     _onStart();
  //     // show error
  //   }
  // }
  // Future<bool> _checkLocationPermission() async {
  //   final access = await LocationPermissions().checkPermissionStatus();
  //   switch (access) {
  //     case PermissionStatus.unknown:
  //     case PermissionStatus.denied:
  //     case PermissionStatus.restricted:
  //       final permission = await LocationPermissions().requestPermissions(
  //         permissionLevel: LocationPermissionLevel.locationAlways,
  //       );
  //       if (permission == PermissionStatus.granted) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //       break;
  //     case PermissionStatus.granted:
  //       return true;
  //       break;
  //     default:
  //       return false;
  //       break;
  //   }
  // }
  // Future<void> _startLocator() async{
  //   await BackgroundLocator.unRegisterLocationUpdate();
  //   print("StartLocator: " + userCellNumber.toString());
  //   Map<String, dynamic> data = {'countInit': 1, 'userNumber': userCellNumber,'userName': userName};
  //   return await BackgroundLocator.registerLocationUpdate(
  //       LocationCallbackHandler.callback,
  //       initCallback: LocationCallbackHandler.initCallback,
  //       initDataCallback: data,
  //       disposeCallback: LocationCallbackHandler.disposeCallback,
  //       iosSettings: IOSSettings(
  //           accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
  //       autoStop: false,
  //       androidSettings: AndroidSettings(
  //           accuracy: LocationAccuracy.NAVIGATION,
  //           interval: 120,
  //           distanceFilter: 0,
  //           client: LocationClient.google,
  //           androidNotificationSettings: AndroidNotificationSettings(
  //               notificationChannelName: 'Location tracking',
  //               notificationTitle: 'Location Tracking',
  //               notificationMsg: 'Track location in background',
  //               notificationBigMsg:
  //               'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
  //               notificationIconColor: Colors.grey,
  //               notificationTapCallback:
  //               LocationCallbackHandler.notificationCallback))
  //   );
  // }
  //
  // void initState() {
  //   super.initState();
  //   // setLoading(true);
  //   // userCellNumber = Provider.of<UserModel>(context, listen: false).phoneNumber;
  //   // userName = Provider.of<UserModel>(context, listen: false).userName;
  //   // if (IsolateNameServer.lookupPortByName(
  //   //     LocationServiceRepository.isolateName) !=
  //   //     null) {
  //   //   IsolateNameServer.removePortNameMapping(
  //   //       LocationServiceRepository.isolateName);
  //   // }
  //   //
  //   // IsolateNameServer.registerPortWithName(
  //   //     port.sendPort, LocationServiceRepository.isolateName);
  //   //
  //   // port.listen(
  //   //       (dynamic data) async {
  //   //     onPort(data);
  //   //   },
  //   // );
  //   // initPlatformState();
  //
  //   startsearching = false;
  //   _isSearching = false;
  //   isLoading2 = false;
  //   startOrStop();
  //   initPage();
  // }

  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  Future<void> startLocationService() async {
    var userCellNumber =
        Provider.of<UserModel>(context, listen: false).phoneNumber;
    var userName = Provider.of<UserModel>(context, listen: false).userName;

    await BackgroundLocator.initialize();
    Map<String, dynamic> data = {
      'countInit': 1,
      'userNumber': userCellNumber,
      'userName': userName
    };
    print(userCellNumber);
    print(userName);
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        autoStop: false,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 120,
            distanceFilter: 0,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIcon: '',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }

  // On back
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  // getLocation()async{
  //   bg.BackgroundGeolocation.onLocation((bg.Location location) {
  //     print('[location] - ${location.coords.latitude}');
  //   });
  //   bg.BackgroundGeolocation.ready(bg.Config(
  //       desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
  //       distanceFilter: 10.0,
  //       stopOnTerminate: false,
  //       startOnBoot: true,
  //       debug: true,
  //       logLevel: bg.Config.LOG_LEVEL_VERBOSE
  //   )).then((bg.State state) {
  //     if (!state.enabled) {
  //       ////
  //       // 3.  Start the plugin.
  //       //
  //       bg.BackgroundGeolocation.start();
  //     }
  //   });
  // }
  getWalletStatus() async {
    var response2 = await OnlineDataBase.getWalletStatus();
    if (response2.statusCode == 200) {
      var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
      print("get wallet data is: " + data2.toString());
      Provider.of<UserModel>(context, listen: false).getWalletStatus(data2);
    } else {
      Fluttertoast.showToast(
          msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
    }
    setState(() {});
  }

  @override
  void initState() {
    // getLocation();
    startLocationService();
    getWalletStatus();
    super.initState();
  }
  // onPort(dynamic data) async {
  //   if(!runningAPI){
  //     setLoading(true);
  //     //final log = await FileManager.readLogFile();
  //     //print(log.toString());
  //     print("@@@@@@@@@@@@@@@@@@");
  //     if(data != null){
  //       userLatLng = Coordinates(data.latitude, data.longitude);
  //     }
  //     print("userLatLng: " + userLatLng.toString());
  //     getData();
  //     //await updateUI(data);
  //   }
  // }
  // Coordinates userLatLng;
  //
  // bool runningAPI = false;
  // String userCellNumber;
  // String userName;
  // DateFormat logDateFormatter = new DateFormat('dd-MM-yyyy');
  // DateFormat timeFormatter = new DateFormat('HH:mm');
  // setLoading(bool loading) {
  //   setState(() {
  //     isLoading = loading;
  //   });
  // }
  // updateTime(Timer timer) {
  //   if (watch.isRunning) {
  //     if (mounted) {
  //       setState(() {
  //         //print("startstop Inside=$startStop");
  //         elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
  //         // print("startstop Inside=$elapsedTime");
  //         if (elapsedTime == sessionLogoutTime) {
  //           stopWatch();
  //         }
  //       });
  //     }
  //   }
  // }
  // startOrStop() {
  //   if (startStop) {
  //     startWatch();
  //   } else {
  //     stopWatch();
  //   }
  // }
  // startWatch() {
  //   setState(() {
  //     startStop = false;
  //     watch.start();
  //     _timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
  //   });
  // }
  // stopWatch() {
  //   setState(() {
  //     startStop = true;
  //     watch.stop();
  //     setTime();
  //     //_logOutUser();
  //   });
  // }
  // setTime() {
  //   var timeSoFar = watch.elapsedMilliseconds;
  //   setState(() {
  //     elapsedTime = transformMilliSeconds(timeSoFar);
  //   });
  // }
  // transformMilliSeconds(int milliseconds) {
  //   int hundreds = (milliseconds / 10).truncate();
  //   int seconds = (hundreds / 100).truncate();
  //   int minutes = (seconds / 60).truncate();
  //   int hours = (minutes / 60).truncate();
  //   String hoursStr = (hours % 60).toString().padLeft(2, '0');
  //   String minutesStr = (minutes % 60).toString().padLeft(2, '0');
  //   String secondsStr = (seconds % 60).toString().padLeft(2, '0');
  //   return "$minutesStr:$secondsStr";
  // }
  // initPage() async {
  //   //getNearByCustomerData();
  //   //checkAndGetLocation();
  //   periodicExecution();
  //   var _location = await location.getLocation();
  //   userLatLng = Coordinates(_location.latitude, _location.longitude);
  //   print("userLatLng: " + userLatLng.toString());
  //   getData();
  // }
  // bool runTimer = true;
  // periodicExecution(){
  //   locationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     if(runTimer)
  //       checkLocation();
  //   });
  //   reloadTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
  //     if(await BackgroundLocator.isServiceRunning()){
  //
  //     }else{
  //       setLoading(true);
  //       getData();
  //     }
  //   });
  // }
  // checkLocation() async {
  //   runTimer = false;
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       print('Location Denied');
  //       checkLocation();
  //     }else{
  //       runTimer = true;
  //     }
  //   }else{
  //     runTimer = true;
  //   }
  // }
  // void getData()async{
  //   setState(() {
  //     _serviceEnabled = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final userData = Provider.of<UserModel>(context, listen: true);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                DrawerHeader(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/profilepic.png',
                            scale: 3,
                          ),
                          Spacer(),
                          Image.asset('assets/icons/splashlogo.png', scale: 8.5)
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      VariableText(
                        text: userData.userName.toString(),
                        fontsize: 16,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: height * 0.0055,
                      ),
                      VariableText(
                        text: userData.email.toString(),
                        fontsize: 12,
                        weight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: height * 0.0055,
                      ),
                      VariableText(
                        text: "Limit: " +
                            userData.usercashReceive.toString() +
                            ' / ' +
                            userData.usercashLimit.toString(),
                        fontsize: 12,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                )),
                DrawerList(
                  text: 'Home',
                  imageSource: "assets/icons/home.png",
                  selected: true,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                // DrawerList(
                //   text: 'Add Customer',
                //   imageSource: "assets/icons/addcustomer.png",
                //   selected: false,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //         context,
                //         NoAnimationRoute(
                //             widget: AddCustomerScreen(
                //               //locationdata: _locationData,
                //             )));
                //   },
                // ),
                // DrawerList(
                //   text: 'Reports',
                //   imageSource: "assets/icons/ledger.png",
                //   selected: false,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //         context,
                //         NoAnimationRoute(
                //             widget: ReportsScreen(
                //               userdata: userData,
                //             )));
                //   },
                // ),
                // DrawerList(
                //     text: 'Total Items',
                //     imageSource: "assets/icons/totalitem.png",
                //     selected: false,
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       Navigator.push(context,
                //           NoAnimationRoute(widget: TotalItemScreen()));
                //     }),
                // DrawerList(
                //     text: 'AGING',
                //     imageSource: "assets/icons/aging.png",
                //     selected: false,
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       Navigator.push(context,
                //           NoAnimationRoute(widget: AgingScreen()));
                //     }),
                // DrawerList(
                //     text: 'Bank Account',
                //     imageSource: "assets/icons/bankaccount.png",
                //     selected: false,
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       Navigator.push(
                //           context,
                //           NoAnimationRoute(
                //               widget: BankAccountScreen(
                //                 shopDetails: customer,
                //                 //lat: _locationData.latitude,
                //                 //long: _locationData.longitude,
                //               )));
                //     }),
                // DrawerList(
                //   text: 'History',
                //   imageSource: "assets/icons/history.png",
                //   selected: false,
                //   onTap: () {
                //     Navigator.of(context).pop();
                //     Navigator.push(
                //         context, NoAnimationRoute(widget: HistoryScreen()));
                //   },
                // ),
                DrawerList(
                  text: 'Logout',
                  imageSource: "assets/icons/logout.png",
                  selected: false,
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('phoneno');
                    prefs.remove('password');
                    Navigator.push(
                        context, NoAnimationRoute(widget: PhoneNumber()));
                  },
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  color: Color(0xffFCFCFC),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: VariableText(
                      text: "@ SKR Sales Link 2021. Version 1.0.0",
                      fontsize: 14.5,
                      weight: FontWeight.w400,
                      fontcolor: textcolorgrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            // leading: Icon(Icons.menu,color: Colors.white,),
            title: Text("Delivery App"),
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "All Shop",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Near by me",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllShop(),
              ScreenTwo(),
            ],
          ),
        ),
      )),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Two"),
      ),
    );
  }
}

class DrawerList extends StatelessWidget {
  final String text;
  final Function onTap;
  final String imageSource;
  final bool selected;

  const DrawerList({
    this.imageSource,
    this.text,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: height * 0.07,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: selected ? Color(0xffFFEEE0) : Color(0xffFCFCFC)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              //alignment: Alignment.center,
                              child: Image.asset(
                                imageSource,
                                scale: 2.6,
                                color: selected ? themeColor1 : textcolorgrey,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 4),
                              child: VariableText(
                                text: text,
                                textAlign: TextAlign.start,
                                fontsize: 15,
                                weight: FontWeight.w400,
                                fontcolor:
                                    selected ? themeColor1 : Color(0xFF555555),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          //SizedBox(height: height*0.0055,)
        ],
      ),
    );
  }
}
