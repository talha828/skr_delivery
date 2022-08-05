import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import 'package:shimmer/shimmer.dart';
import 'package:skr_delivery/model/addressModel.dart';
import 'package:skr_delivery/model/customerList.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/main_screen/locationandrefresh.dart';
import 'package:skr_delivery/screens/main_screen/nearbyyouandviewall.dart';
import 'package:intl/intl.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/viewallScreen/view_all_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import '../../ApiCode/online_database.dart';
import 'main_screen_card.dart';
import 'main_search_field.dart';
import 'package:geolocator/geolocator.dart' as geo;

class AllShop extends StatefulWidget {
  @override
  _AllShopState createState() => _AllShopState();
}

class _AllShopState extends State<AllShop> {
  // var currentLocation;
  // var myLocation;
  // var city;
  // var localArea;
  // bool isLoading = false;
  // bool runningAPI = false;
  // List<CustomerModel> customer = [];
  // List<CustomerModel> limitedcustomer = [];
  // List<CustomerModel> nearByCustomers = [];
  // List<CustomerModel> _list = [];
  // List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  // int selectedIndex = 0;
  // List imageLinks = [];
  // var f = NumberFormat("###,###.0#", "en_US");

  // current location
  // getUserLocation() async {
  //   //call this async method from whereever you need
  //   LocationData myLocation;
  //   String error;
  //   Location location = new Location();
  //   try {
  //     myLocation = await location.getLocation();
  //     var _location = await location.getLocation();
  //     userLatLng = Coordinates(_location.latitude, _location.longitude);
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       error = 'please grant permission';
  //       print(error);
  //     }
  //     if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
  //       error = 'permission denied- please enable it from app settings';
  //       print(error);
  //     }
  //     myLocation = null;
  //   }
  //   currentLocation = myLocation;
  //   final coordinates =
  //       new Coordinates(myLocation.latitude, myLocation.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   print(
  //       ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  //   city = first.locality.toString();
  //   localArea = first.subLocality.toString();
  //   setState(() {});
  // }
  // getAddressFromLatLng() async {
  //   Location location=new Location();
  //   var data =await location.getLocation();
  //   userLatLng=Coordinates(data.latitude,data.longitude);
  //   var lat=data.latitude;
  //   var lng=data.longitude;
  //   //userLatLng=Coordinates(lat, lng);setState(() {});
  //   List<AddressModel>addressList=[];
  //   String mapApiKey="AIzaSyDhBNajNSwNA-38zP7HLAChc-E0TCq7jFI";
  //   String _host = 'https://maps.google.com/maps/api/geocode/json';
  //   final url = '$_host?key=$mapApiKey&language=en&latlng=$lat,$lng';
  //   print(url);
  //   if(lat != null && lng != null){
  //     var response = await http.get(Uri.parse(url));
  //     if(response.statusCode == 200) {
  //       Map data = jsonDecode(response.body);
  //       String _formattedAddress = data["results"][0]["formatted_address"];
  //       var address = data["results"][0]["address_components"];
  //       for(var i in address){
  //         addressList.add(AddressModel.fromJson(i));
  //       }
  //       setState(() {
  //         localArea=addressList[3].shortName;
  //       });
  //       print("response ==== $_formattedAddress");
  //       return _formattedAddress;
  //     } else return null;
  //   } else return null;
  // }

  // set loading
  bool isLoading= false;
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  // get customer
  String actualAddress="Searching";
  void getAllCustomerData(bool data) async {
    if(data){
      try {
        List<CustomerModel>customer=[];
        Provider.of<CustomerList>(context,listen: false).setLoading(true);
        var data =await Location().getLocation();
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
          var response = await OnlineDataBase.getAllCustomer();
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
            Provider.of<CustomerList>(context,listen: false).storeResponse2(data);
            Provider.of<CustomerList>(context,listen: false).getAllCustomer(customer);
            //Provider.of<CustomerList>(context,listen: false).getDues(customer);
           // Provider.of<CustomerList>(context,listen: false).getAssignShop(customer);
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
  calculateDistance(double lat1,double long1,double lat2,double long2) {
    var distance = geo.Geolocator.distanceBetween(lat2,
        long2, lat1, long1);
    return distance / 1000;
  }
  Coordinates userLatLng;
  // calculateDistance(Coordinates shopLatLng) {
  //   var distance = geo.Geolocator.distanceBetween(userLatLng.latitude,
  //       userLatLng.longitude, shopLatLng.latitude, shopLatLng.longitude);
  //   return distance / 1000;
  // }
  getLocation()async{
    var location=await Location().getLocation();
    userLatLng=Coordinates(location.latitude,location.longitude);
    Provider.of<CustomerList>(context,listen: false).updateList2(userLatLng);
  }
  @override
  void initState() {
    getAllCustomerData(true);
    super.initState();
  }

  // Future<void> refresh() async {
  //   getAddressFromLatLng();
  //   getAllCustomerData();
  //   getNearByCustomerData();
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var customer=Provider.of<CustomerList>(context);
    return
      Scaffold(
        appBar: MyAppBar(
    title: 'All Shop',
      ontap: () =>Navigator.pop(context),
    ),
          body: Stack(
            children:[ SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ShowLocationAndRefresh(
                    //   localArea: localArea,
                    //   city: "Karachi",
                    //   onTap: () {
                    //     getAddressFromLatLng();
                    //     getAllCustomerData();
                    //     getNearByCustomerData();
                    //   },
                    // ),
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
                                        customerModel: customer.customerData,
                                        lat: userLatLng.latitude,
                                        long: userLatLng.longitude,
                                      )));
                            },
                            // enable: false,
                          ),
                        ),
                        IconButton(onPressed: ()=>getAllCustomerData(true), icon: Icon(Icons.refresh,color: themeColor1,)),
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
                            customer.customerData.length,
                        onTap: () {}
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
                                itemCount: customer.customerData.length>10?10:customer.customerData.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CustomShopContainer(
                                        customerList: customer.customerData,
                                        height: height,
                                        width: width,
                                        customerData:customer.customerData[index],
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
            ),

      customer.customerData.length<1 && customer.loading != true ?
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
   ]));
  }
}
