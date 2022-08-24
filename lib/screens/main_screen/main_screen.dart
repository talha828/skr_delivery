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
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/locationServices/broadcast.dart';
import 'package:skr_delivery/locationServices/location_callback_handler.dart';
import 'package:skr_delivery/locationServices/location_service_repository.dart';
import 'package:skr_delivery/model/addressModel.dart';
import 'package:skr_delivery/model/customerList.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:skr_delivery/screens/loginScreen/phonenumber/phonenumber.dart';
import 'package:skr_delivery/screens/main_screen/main_search_field.dart';
import 'package:skr_delivery/screens/main_screen/nearbyyouandviewall.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/screens/viewallScreen/view_all_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import '../assign_shop.dart';
import 'all_shop.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;

class MainScreen extends StatefulWidget {
  bool check;
  MainScreen({this.check});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userCellNumber;
  String userName;


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
  getWalletStatus() async {
    var response2 = await OnlineDataBase.getWalletStatus().catchError((e)=>Fluttertoast.showToast(
        msg: "Error: " +e.toString(), toastLength: Toast.LENGTH_LONG));
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
  calculateDistance(double lat1,double long1,double lat2,double long2) {
    var distance = geo.Geolocator.distanceBetween(lat2,
        long2, lat1, long1);
    return distance / 1000;
  }
  Coordinates userLatLng;
  String actualAddress="Searching";
  void getAllCustomerData(bool data) async {
    if(data){
      try {
        List<CustomerModel>customer=[];
        Provider.of<CustomerList>(context,listen: false).setLoading(true);
        var data =await loc.Location().getLocation();
        List<AddressModel>addressList=[];
        userLatLng=Coordinates(data.latitude,data.longitude);
        String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
        String _host = 'https://maps.google.com/maps/api/geocode/json';
        final url = '$_host?key=$mapApiKey&language=en&latlng=${userLatLng.latitude},${userLatLng.longitude}';
        print(url);
        if(userLatLng.latitude != null && userLatLng.longitude != null){
          var response1 = await http.get(Uri.parse(url));
          if(response1.statusCode == 200) {
            Map data = jsonDecode(response1.body);
            String _formattedAddress = data["results"][0]["formatted_address"];
            var address = data["results"][0]["address_components"];
            for(var i in address){
              addressList.add(AddressModel.fromJson(i));
            }
            actualAddress=addressList[3].shortName;
            Provider.of<CustomerList>(context,listen: false).updateAddress(actualAddress);
            print("response ==== $_formattedAddress");
            _formattedAddress;
          }
          var response = await OnlineDataBase.getAssignShop();
          print("Response code is " + response.statusCode.toString());
          if (response.statusCode == 200) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            //print("Response is" + data.toString());

            for (var item in data["results"]) {
              double dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLatLng.latitude,userLatLng.longitude);
              customer.add(CustomerModel.fromModel(item,distance: dist));
            }
            customer.sort((a,b)=>a.distance.compareTo(b.distance));
            //Provider.of<CustomerList>(context,listen: false).clearList();
            Provider.of<CustomerList>(context,listen: false).storeResponse1(data);
            // Provider.of<CustomerList>(context,listen: false).getAllCustomer(customer);
            // Provider.of<CustomerList>(context,listen: false).getDues(customer);
            Provider.of<CustomerList>(context,listen: false).getAssignShop(customer);
            print("done");
            setState(() {

            });
            //print("length is"+limitedcustomer.length.toString());
            Provider.of<CustomerList>(context,listen: false).setLoading(false);

          } else if (response.statusCode == 400) {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            Fluttertoast.showToast(
                msg: "${data['results'].toString()}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
            Provider.of<CustomerList>(context,listen: false).setLoading(false);
          }}
      } catch (e, stack) {
        print('exception is' + e.toString());
        Fluttertoast.showToast(
            msg: "Error: " + e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Provider.of<CustomerList>(context,listen: false).setLoading(false);
      }
    }
  }
  bool isLoading=false;
  @override
  void initState() {
    // getLocation();
    startLocationService();
    getWalletStatus();
    getAllCustomerData(widget.check);
    super.initState();
  }
  getLocation()async{
    var location=await loc.Location().getLocation();
    userLatLng=Coordinates(location.latitude,location.longitude);
    Provider.of<CustomerList>(context,listen: false).updateList1(userLatLng);
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final userData = Provider.of<UserModel>(context, listen: true);
    final address = Provider.of<CustomerList>(context, listen: true).address;
    final customer = Provider.of<CustomerList>(context, listen: true);
    print(userData.userName);
    return WillPopScope(
      onWillPop: _onWillPop,
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
                  DrawerList(
                    text: 'All Shop',
                    imageSource: "assets/icons/locationpin.png",
                    selected: false,
                    onTap: ()  {
                      Navigator.push(
                          context, NoAnimationRoute(widget: AllShop()));
                    },
                  ),
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
              title: Center(child: Text("Delivery App",)),
              actions: [
                SizedBox(width: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                  child: Center(
                    child: VariableText(
                      text: address,
                      fontsize: 15,
                      fontcolor: Colors.white,
                      weight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: width * 0.65,
                                child: MainSearchField(
                                  width: width,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SearchScreen(
                                              customerModel: customer.assign,
                                              lat: userLatLng.latitude,
                                              long: userLatLng.longitude,
                                            )));
                                  },
                                  // enable: false,
                                ),
                              ),
                              IconButton(onPressed: (){
                                startLocationService();
                                getAllCustomerData(true);}, icon: Icon(Icons.refresh,color: themeColor1,)),
                              IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: (){
                                    getLocation();
                                  }, icon: Image.asset("assets/update.png",color: themeColor1,width: 25,height: 25,))
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: NearByYouAndViewAll(
                              itemCount:
                              customer.assign.length > 10 ? 10 : customer.assign.length,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAllScreen(
                                        customerList: customer.assign,
                                      ))),
                            ),
                          ),
                          Container(
                            child: customer.loading
                                ? Container(
                              height: 480,
                              child: Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                baseColor: Colors.grey.withOpacity(0.4),
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 4,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        CustomShopContainerLoading(
                                          height: height,
                                          width: width,
                                        ),
                                        SizedBox(
                                          height: height * 0.025,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            )
                                :  Container(
                                child: SingleChildScrollView(
                                  child: Container(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: customer.assign.length>10?10:customer.assign.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            CustomShopContainer(
                                              customerList: customer.assign,
                                              height: height,
                                              width: width,
                                              customerData:customer.assign[index],
                                              //isLoading2: isLoading2,
                                              //enableLocation: _serviceEnabled,
                                              lat: 1.0,
                                              long:1.0,
                                              showLoading: (value) {
                                                setState(() {
                                                  isLoading = value;
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: height * 0.025,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ) ,
                  customer.assign.length<1 && customer.loading != true ?
                  Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Text("No shops are Found",textAlign: TextAlign.center,),
                        ]
                    ),
                  ):Container(),
                  isLoading?Positioned.fill(child: ProcessLoading()):Container()
                ],
              ),
            )
          ));
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
