import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/assign_shop_model.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/viewallScreen/view_all_screen.dart';
import 'package:intl/intl.dart';
import 'main_screen/locationandrefresh.dart';
import 'main_screen/main_screen_card.dart';
import 'main_screen/main_search_field.dart';
import 'main_screen/nearbyyouandviewall.dart';

class AssignShop extends StatefulWidget {


  @override
  State<AssignShop> createState() => _AssignShopState();
}

class _AssignShopState extends State<AssignShop> {
  String localArea;
  String city;
  Coordinates userLatLng;
  var currentLocation;
  List<AssignShopModel> customer = [];
  List<AssignShopModel> limitedcustomer = [];
  List<AssignShopModel> nearByCustomers = [];
  List<AssignShopModel> _list = [];
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  int selectedIndex = 0;
  List imageLinks = [];
  bool isLoading = false;
  bool runningAPI = false;
  var f = NumberFormat("###,###.0#", "en_US");

  calculateDistance(Coordinates shopLatLng) {
    var distance = geo.Geolocator.distanceBetween(userLatLng.latitude,
        userLatLng.longitude, shopLatLng.latitude, shopLatLng.longitude);
    return distance / 1000;
  }
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  getUserLocation() async {
    //call this async method from whereever you need
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
      var _location = await location.getLocation();
      userLatLng = Coordinates(_location.latitude, _location.longitude);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates =
    new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    city = first.locality.toString();
    localArea = first.subLocality.toString();
    setState(() {});
  }
  void getAllCustomerData() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.getAssignShop();
      print("Response code is " + response.statusCode.toString());
      // var image= await OnlineDataBase.getImage();

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // //print("Response is" + data.toString());
        // var imageData = jsonDecode(utf8.decode(image.bodyBytes));
        // for (var imageLink in imageData["results"]) {
        //   imageLinks.add(imageLink["IMAGE_URL"]);
        //   print(imageLink["IMAGE_URL"]);
        // }
        int i=0;
        for (var item in data["results"]) {
          customer.add(AssignShopModel.fromJson(item));
          print(i);
          i++;
        }
        // for (int i = 0; i < 4; i++) {
        //   print("name:${customer[i]}");
        //   print("data length :${customer[i].dues}");
        //   limitedcustomer.add(AssignShopModel.fromJson(data["results"][i]));
        // }
        //print("length is"+limitedcustomer.length.toString());
        // for (var item in data["results"]) {
        //   _list.add(AssignShopModel.fromJson(item));
        // }
        setLoading(false);
      } else if (response.statusCode == 400) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
            msg: "${data['results'].toString()}",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong try again letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getUserLocation();
    getAllCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    ShowLocationAndRefresh(
                      localArea: localArea,
                      city: city,
                      onTap: ()=>getAllCustomerData
                    ),
                    // MainSearchField(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) => SearchScreen(
                    //               customerModel: customers,
                    //               lat: userLatLng.latitude,
                    //               long: userLatLng.longitude,
                    //             )));
                    //   },
                    //   // enable: false,
                    // ),
                    // NearByYouAndViewAll(
                    //   itemCount:
                    //   customer.length > 10 ? 10 : customer.length,
                    //   onTap: () => Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ViewAllScreen(
                    //             nearByCustomers: nearByCustomers,
                    //             customerList: customer,
                    //             lat: userLatLng.latitude,
                    //             long: userLatLng.longitude,
                    //           ))),
                    // ),
                    Container( 
                      child: customer.length < 0
                          ? Container(
                        height: 380,
                        child: Center(child: Text("No Shop Found")),
                      )
                          : ListView.builder(
                          shrinkWrap: true,
                          itemCount: customer.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            print(customer[index].dATA[3].vALUE);
                            return customer[index].dATA[3].vALUE.toString()=='Sami Fahim'?MainScreenCards(
                              height: height,
                              width: width,
                              f: f,
                              menuButton: menuButton,
                              code: customer[index]
                                  .cUSTCODE
                                  .toString(),
                              category: customer[index]
                                  .cATEGORY
                                  .toString(),
                              shopName: customer[index]
                                  .cUSTOMER
                                  .toString(),
                              address: customer[index]
                                  .aDDRESS
                                  .toString(),
                              name: customer[index]
                                  .oWNER
                                  .toString(),
                              phoneNo: customer[index]
                                  .pHONE1
                                  .toString(),
                              lastVisit: customer[index]
                                  .lASTVISTDAYS
                                  .toString(),
                              dues: (customer[index].dUES.toString() ==
                                  '0')
                                  ? "0"
                                  : customer[index].dUES.toString(),
                              lastTrans: customer[index]
                                  .lASTTRANSDAYS
                                  .toString(),
                              outstanding: (customer[index]
                                  .oUTSTANDING
                                  .toString() ==
                                  '0')
                                  ? "0"
                                  : customer[index]
                                  .oUTSTANDING
                                  .toString(),
                              shopAssigned: customer[index].sHOPASSIGNED,
                              lat: customer[index].lATITUDE,
                              long: customer[index].lONGITUDE,
                              customerData: customer[index],
                              image:
                              "https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.indianexpress.com%2F2021%2F12%2Fdoctor-strange-2-1200.jpg&imgrefurl=https%3A%2F%2Findianexpress.com%2Farticle%2Fentertainment%2Fhollywood%2Fdoctor-strange-2-suggest-benedict-cumberbatch-sorcerer-supreme-might-lead-avengers-7698058%2F&tbnid=GxuE_SM1fXrAqM&vet=12ahUKEwjr4bj575_3AhVMxqQKHSC5BRAQMygBegUIARDbAQ..i&docid=6gb_YRZyTk5MWM&w=1200&h=667&q=dr%20strange&ved=2ahUKEwjr4bj575_3AhVMxqQKHSC5BRAQMygBegUIARDbAQ",
                              showLoading: (value) {
                                setState(() {
                                  isLoading = value;
                                });
                              },
                            ):Container();
                          }),
                    )
                  ],
                ),
              ),
            ) ,
            isLoading?loader():Container(),
          ],
        ),
      )
    );
  }
}
