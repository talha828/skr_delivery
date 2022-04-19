import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geo;
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/main_screen/locationandrefresh.dart';
import 'package:skr_delivery/screens/main_screen/nearbyyouandviewall.dart';
import 'package:intl/intl.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/viewallScreen/view_all_screen.dart';
import '../../online_database.dart';
import 'main_screen_card.dart';
import 'main_search_field.dart';

class AllShop extends StatefulWidget {
  @override
  _AllShopState createState() => _AllShopState();
}

class _AllShopState extends State<AllShop> {
  var currentLocation;
  var myLocation;
  var city;
  var localArea;
  bool isLoading = false;
  bool runningAPI = false;
  List<CustomerModel> customer = [];
  List<CustomerModel> limitedcustomer = [];
  List<CustomerModel> nearByCustomers = [];
  List<CustomerModel> _list = [];
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  int selectedIndex = 0;
  List imageLinks=[];
  var f = NumberFormat("###,###.0#", "en_US");

  // current location
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
  // set loading
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  // get customer
  void getAllCustomerData() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.getAllCustomer();
      print("Response code is " + response.statusCode.toString());
      var image= await OnlineDataBase.getImage();

      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // //print("Response is" + data.toString());
        // var imageData = jsonDecode(utf8.decode(image.bodyBytes));
        // for (var imageLink in imageData["results"]) {
        //   imageLinks.add(imageLink["IMAGE_URL"]);
        //   print(imageLink["IMAGE_URL"]);
        // }
        for (var item in data["results"]) {
          customer.add(CustomerModel.fromModel(item));
        }
        for (int i = 0; i < 4; i++) {
          print("name:${customer[i].customerName}");
          print("data length :${customer.length}");
          limitedcustomer.add(CustomerModel.fromModel(data["results"][i]));
        }
        //print("length is"+limitedcustomer.length.toString());
        for (var item in data["results"]) {
          _list.add(CustomerModel.fromModel(item));
        }
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
  void getNearByCustomerData() async {
    try {
      runningAPI = true;
      var response = await OnlineDataBase.getAllCustomer();
      if (response.statusCode == 200) {
        customer.clear();
        nearByCustomers.clear();
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        for (var item in data["results"]) {
          if(item['LATITUDE'] != null && item['LONGITUDE'] != null &&
              item['LATITUDE'].toString().length > 2 && item['LONGITUDE'].toString().length > 2){
            double dist = calculateDistance(Coordinates(item['LATITUDE'], item['LONGITUDE']));
            if(dist <= 2.0){
              //print(dist.toString() + " KM");
              nearByCustomers.add(CustomerModel.fromModel(item, distance: dist));
            }
          }
          customer.add(CustomerModel.fromModel(item));
        }
        for(int i=0; i < nearByCustomers.length-1; i++){
          for(int j=0; j < nearByCustomers.length-i-1; j++){
            if(nearByCustomers[j].distance > nearByCustomers[j+1].distance){
              CustomerModel temp = nearByCustomers[j];
              nearByCustomers[j] = nearByCustomers[j+1];
              nearByCustomers[j+1] = temp;
            }
          }
        }
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
      runningAPI = false;
    } catch (e, stack) {
      print('exception is: ' + e.toString());
      setLoading(false);
      runningAPI = false;
      Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  Coordinates userLatLng;

  calculateDistance(Coordinates shopLatLng){
    var distance = geo.Geolocator.distanceBetween(
        userLatLng.latitude, userLatLng.longitude,
        shopLatLng.latitude, shopLatLng.longitude);
    return distance/1000;
  }
  @override
  void initState() {
    super.initState();
    getUserLocation();
    getAllCustomerData();
    getNearByCustomerData();
  }
  Future<void>refresh()async{
    getUserLocation();
    getAllCustomerData();
    getNearByCustomerData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
        alignment: Alignment.center,
        children: [
      Scaffold(
          body: RefreshIndicator(
            displacement: 20,
            onRefresh: refresh,
            child: SingleChildScrollView(
              child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShowLocationAndRefresh(
                  localArea: localArea,
                  city: city,
                  onTap:(){
                    getUserLocation();
                    getAllCustomerData();
                    getNearByCustomerData();
                  },
                ),
                MainSearchField(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SearchScreen(
                              customerModel: customer,
                              lat: userLatLng.latitude,
                              long: userLatLng.longitude,
                            )));
                  },
                 // enable: false,
                ),
                NearByYouAndViewAll(
                  itemCount: nearByCustomers.length>10 ?10:nearByCustomers.length,
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllScreen(nearByCustomers: nearByCustomers,customerList: customer,lat: userLatLng.latitude,long: userLatLng.longitude,))),
                ),
               Container(
                 child: nearByCustomers.length<10?Container(
                   height: 380,
                   child: Center(child: Text("No Shop Found")),
                 ):ListView.builder(
                   shrinkWrap: true,
                     itemCount: 10,
                     physics: NeverScrollableScrollPhysics(),
                     itemBuilder:(context,index){
                       return  MainScreenCards(
                         height: height,
                         width: width,
                         f: f,
                         menuButton: menuButton,
                         code: nearByCustomers[index].customerCode.toString(),
                         category: nearByCustomers[index].customerCategory.toString(),
                         shopName: nearByCustomers[index].customerShopName.toString(),
                         address: nearByCustomers[index].customerAddress.toString(),
                         name: nearByCustomers[index].customerContactPersonName.toString(),
                         phoneNo: nearByCustomers[index].customerContactNumber.toString(),
                         lastVisit: nearByCustomers[index].lastVisitDay.toString(),
                         dues: nearByCustomers[index].dues.toString(),
                         lastTrans: nearByCustomers[index].lastTransDay.toString(),
                         outstanding: nearByCustomers[index].outStanding.toString(),
                         shopAssigned: nearByCustomers[index].shopAssigned,
                         lat: nearByCustomers[index].customerLatitude,
                         long: nearByCustomers[index].customerLongitude,
                         image: imageLinks[index],
                         showLoading: (value) {
                           setState(() {
                             isLoading = value;
                           });
                         },
                       );
                     } ),
               )
              ],
        ),
      ),
            ),
          )),
          isLoading?loader():Container()
    ]);
  }
}
