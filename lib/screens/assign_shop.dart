// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:geocoder/model.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:skr_delivery/ApiCode/online_database.dart';
// import 'package:skr_delivery/model/addressModel.dart';
// import 'package:skr_delivery/model/assign_shop_model.dart';
// import 'package:skr_delivery/model/customerList.dart';
// import 'package:skr_delivery/model/customerModel.dart';
// import 'package:skr_delivery/model/user_model.dart';
// import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
// import 'package:skr_delivery/screens/search_screen/search_screen.dart';
// import 'package:skr_delivery/screens/viewallScreen/view_all_screen.dart';
// import 'package:intl/intl.dart';
// import 'package:skr_delivery/screens/widget/common.dart';
// import 'package:skr_delivery/screens/widget/constant.dart';
// import 'main_screen/locationandrefresh.dart';
// import 'main_screen/main_screen_card.dart';
// import 'main_screen/main_search_field.dart';
// import 'main_screen/nearbyyouandviewall.dart';
//
// class AssignShop extends StatefulWidget {
//
//
//   @override
//   State<AssignShop> createState() => _AssignShopState();
// }
//
// class _AssignShopState extends State<AssignShop> {
//
//
//   bool isLoading = false;
//   var f = NumberFormat("###,###.0#", "en_US");
//
//
//   setLoading(bool loading) {
//     setState(() {
//       isLoading = loading;
//     });
//   }
//   Coordinates userLatLng;
//
//
//   // void getAllCustomerData() async {
//   //   try {
//   //     setLoading(true);
//   //     var response = await OnlineDataBase.getAssignShop();
//   //     print("Response code is " + response.statusCode.toString());
//   //     // var image= await OnlineDataBase.getImage();
//   //
//   //     if (response.statusCode == 200) {
//   //       var data = jsonDecode(utf8.decode(response.bodyBytes));
//   //       // //print("Response is" + data.toString());
//   //       // var imageData = jsonDecode(utf8.decode(image.bodyBytes));
//   //       // for (var imageLink in imageData["results"]) {
//   //       //   imageLinks.add(imageLink["IMAGE_URL"]);
//   //       //   print(imageLink["IMAGE_URL"]);
//   //       // }
//   //       int i=0;
//   //       for (var item in data["results"]) {
//   //         customer.add(AssignShopModel.fromJson(item));
//   //         print(i);
//   //         i++;
//   //       }
//   //       // for (int i = 0; i < 4; i++) {
//   //       //   print("name:${customer[i]}");
//   //       //   print("data length :${customer[i].dues}");
//   //       //   limitedcustomer.add(AssignShopModel.fromJson(data["results"][i]));
//   //       // }
//   //       //print("length is"+limitedcustomer.length.toString());
//   //       // for (var item in data["results"]) {
//   //       //   _list.add(AssignShopModel.fromJson(item));
//   //       // }
//   //       setLoading(false);
//   //     } else if (response.statusCode == 400) {
//   //       var data = jsonDecode(utf8.decode(response.bodyBytes));
//   //       setLoading(false);
//   //       Fluttertoast.showToast(
//   //           msg: "${data['results'].toString()}",
//   //           toastLength: Toast.LENGTH_SHORT,
//   //           backgroundColor: Colors.black87,
//   //           textColor: Colors.white,
//   //           fontSize: 16.0);
//   //     }
//   //   } catch (e, stack) {
//   //     print('exception is' + e.toString());
//   //     setLoading(false);
//   //     Fluttertoast.showToast(
//   //         msg: "Something went wrong try again letter",
//   //         toastLength: Toast.LENGTH_SHORT,
//   //         backgroundColor: Colors.black87,
//   //         textColor: Colors.white,
//   //         fontSize: 16.0);
//   //   }
//   // }
//   getLocation()async{
//     var location=await Location().getLocation();
//     userLatLng=Coordinates(location.latitude,location.longitude);
//     Provider.of<CustomerList>(context,listen: false).updateList(userLatLng);
//   }
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width=MediaQuery.of(context).size.width;
//     var height=MediaQuery.of(context).size.height;
//     final userData = Provider.of<UserModel>(context, listen: true);
//     final customer = Provider.of<CustomerList>(context, listen: true);
//     print(userData.userName);
//     // print(customer[1].dATA[3].vALUE.toString());
//
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body:Container(
//           child: Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       // ShowLocationAndRefresh(
//                       //     localArea: customer.address,
//                       //     city: "Karachi",
//                       //     onTap: (){}//TODO re load//////////
//                       // ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             width: width * 0.6,
//                             child: MainSearchField(
//                               width: width,
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => SearchScreen(
//                                           customerModel: customer.customerData,
//                                           lat: userLatLng.latitude,
//                                           long: userLatLng.longitude,
//                                         )));
//                               },
//                               // enable: false,
//                             ),
//                           ),
//                           IconButton(onPressed: (){}, icon: Icon(Icons.refresh,color: themeColor1,)),
//                           IconButton(
//                               padding: EdgeInsets.all(0),
//                               onPressed: (){
//                                 getLocation();
//                               }, icon: Image.asset("assets/update.png",color: themeColor1,width: 25,height: 25,))
//                         ],
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(bottom: 10),
//                         child: NearByYouAndViewAll(
//                           itemCount:
//                           customer.assign.length > 10 ? 10 : customer.assign.length,
//                           onTap: () => Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => ViewAllScreen(
//                                     nearByCustomers: customer.assign,
//                                     customerList: customer,
//                                     lat: userLatLng.latitude,
//                                     long: userLatLng.longitude,
//                                   ))),
//                         ),
//                       ),
//                       Container(
//                         child: customer.loading
//                             ? Container(
//                           height: 480,
//                           child: Shimmer.fromColors(
//                             period: Duration(seconds: 1),
//                             baseColor: Colors.grey.withOpacity(0.4),
//                             highlightColor: Colors.grey.shade100,
//                             enabled: true,
//                             child: ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               physics: NeverScrollableScrollPhysics(),
//                               itemCount: 4,
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     CustomShopContainerLoading(
//                                       height: height,
//                                       width: width,
//                                     ),
//                                     SizedBox(
//                                       height: height * 0.025,
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         )
//                             :  Container(
//                             child: SingleChildScrollView(
//                               child: Container(
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: customer.assign.length>10?10:customer.assign.length,
//                                   itemBuilder: (context, index) {
//                                     return Column(
//                                       children: [
//                                         CustomShopContainer(
//                                           customerList: customer.assign,
//                                           height: height,
//                                           width: width,
//                                           customerData:customer.assign[index],
//                                           //isLoading2: isLoading2,
//                                           //enableLocation: _serviceEnabled,
//                                           lat: 1.0,
//                                           long:1.0,
//                                           showLoading: (value) {
//                                             setState(() {
//                                               isLoading = value;
//                                             });
//                                           },
//                                         ),
//                                         SizedBox(
//                                           height: height * 0.025,
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             )
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ) ,
//               customer.assign.length<1 && customer.loading != true ?
//               Container(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children:[
//                       Text("No shops are Found",textAlign: TextAlign.center,),
//                     ]
//                 ),
//               ):Container(),
//               isLoading?Positioned.fill(child: ProcessLoading()):Container()
//             ],
//           ),
//         )
//     );
//   }
// }
