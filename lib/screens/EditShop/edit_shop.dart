import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
///image picker use here
//import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/area_model.dart';
import 'package:skr_delivery/model/city_model.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/partycategories.dart';
import 'package:skr_delivery/model/town_model.dart';
import 'package:skr_delivery/screens/EditShop/text_feild_edit_shop.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';


class EditShopScreen extends StatefulWidget {
  var lat, long;
  var locationdata;

  CustomerModel shopData;
  File _image1;

  EditShopScreen({this.lat, this.long, this.shopData, this.locationdata});

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  bool showImage = false;
  List edit_image = [];
  var actualaddress = "Searching....";
  String base64Image;
  File image;
  bool isLoading = false;
  bool updateLocation = false;
  String apiAddress;
  String CustomerId;
  bool hasArea = false;
  bool hasPartyCategory = false;

  bool _serviceEnabled = false;
  LocationData _locationData;
  Location location = new Location();
  Town sel_town;
  DateTime selectedDate = DateTime.now();
  bool checkbox = false;
  String formattedDate;
  TextEditingController name;
  TextEditingController secondname;
  TextEditingController phoneno;
  TextEditingController secondphoneno;
  TextEditingController address;
  TextEditingController currentlocation;
  TextEditingController shoptown;
  TextEditingController shopname;
  List<Town> townList = [];

  List<City> cities = [];
  City sel_cities;
  List<Area> areas = [];
  Area sel_areas;
  List<PartyCategories> party_categories = [];
  PartyCategories sel_party_categories;

  CustomerModel userDetails;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController(
        text: widget.shopData.customerContactPersonName.toString());
    secondname =
        TextEditingController(text: widget.shopData.customerContactPersonName2);
    phoneno =
        TextEditingController(text: widget.shopData.customerContactNumber);
    secondphoneno =
        TextEditingController(text: widget.shopData.customerContactNumber2);
    address = TextEditingController(text: widget.shopData.customerAddress);
    shopname = TextEditingController(text: widget.shopData.customerShopName);
    setLoading(true);
    checkLocation();
    initPage();
    getUser();
  }

  getUser() async {
    var response =
        await OnlineDataBase.getSingleCustomer(widget.shopData.customerCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data.toString());
      userDetails = CustomerModel.fromModel(data['results'][0]);
      print(userDetails.customerCityName);
      getAllCities();
      getPartyCategory();
    } else {
      print("User not found!!!!!");
      setLoading(false);
    }
  }

  checkLocation() async {
    if (widget.locationdata == null) {
      _serviceEnabled = await location.requestService();
    } else {}
    widget.locationdata = await location.getLocation();
    final coordinates = new Coordinates(
        widget.locationdata.latitude, widget.locationdata.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      actualaddress = addresses.first.addressLine;
    });
    print("address is" + actualaddress.toString());
  }

  Future<List<City>> getAllCities() async {
    print(widget.shopData.customerCityName);
    List<City> tempCity = await OnlineDataBase.getAllCities();
    for (var item in tempCity) {
      cities.add(item);
    }
    for (var item in cities) {
      if (item.cityName == userDetails.customerCityName) {
        setState(() {
          sel_cities = item;
        });
        break;
      }
    }
    if(sel_cities != null)
    {
        await getAreas(sel_cities.cityCode);
    }
    setLoading(false);
  }

  Future<List<Area>> getAreas(cityID) async {
    List<Area> tempArea = await OnlineDataBase.getAreaByCity(cityID);
    for (var item in tempArea) {
      if (item.areaName == userDetails.customerAreaName) {
        setState(() {
          sel_areas = item;
        });
      }
    }

    setState(() {
      areas = tempArea;
      hasArea = true;
    });
  }

  Future<List<PartyCategories>> getPartyCategory() async {
    print("party ${userDetails.customerPartyCategory}");
    List<PartyCategories> tempPartyCategory =
        await OnlineDataBase.getPartyCategories();
    for (var item in tempPartyCategory) {
      if (item.partyCategoriesName == userDetails.customerPartyCategory) {
        sel_party_categories = item;
      }
    }

    setState(() {
      party_categories = tempPartyCategory;
    });
  }

  initPage() async {
    apiAddress = widget.shopData.customerAddress.toString();
    final coordinates = new Coordinates(widget.lat, widget.long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // actualaddress = addresses.first.subLocality.toString()+" "+addresses.first.locality.toString();
    actualaddress = addresses.first.addressLine;
    //print("data is"+actualaddress.toString());
    setState(() {});
  }

  _uploadImg(bool fromCamera) async {
    if(fromCamera){
      File image = await ImagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50
      );
      if(image !=null){
        print(image.path);
        setState(() {
          this.image = image;
          showImage = true;
        });
      }
    }else{
      File image = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      );
      if(image !=null){
        print(image.path);
        setState(() {
          this.image = image;
          showImage = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: themeColor2),
              elevation: 0.5,
              backgroundColor: themeColor1,
              title: VariableText(
                text: 'Edit Shop',
                fontsize: 16,
                fontcolor: themeColor2,
                weight: FontWeight.w600,
              ),
            ),
            body: isLoading
                ? loader()
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      Container(
                        height: height * 0.13,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Color(0xffE0E0E099).withOpacity(0.6),
                          )
                        ], color: themeColor2),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:5.0),
                                child: Row(
                                  children: [
                                    VariableText(
                                      text: 'Current Location',
                                      fontsize: 15,
                                      fontcolor: textcolorblack,
                                      weight: FontWeight.w500,
                                    ),
                                    Spacer(),
                                    InkWell(
                                        onTap: () {
                                          if (updateLocation == false) {
                                            setState(() {
                                              updateLocation = true;
                                            });
                                          } else {
                                            setState(() {
                                              updateLocation = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                          color: themeColor1,
                                            borderRadius: BorderRadius.circular(3)
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              VariableText(text: "Copy",fontsize: 12,fontcolor: Colors.white,),
                                              SizedBox(width: 8),
                                              Image.asset(
                                                'assets/icons/locationpin.png',
                                                scale: 4.5,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                //color: Colors.red,
                                child: Wrap(
                                  children: [
                                    VariableText(
                                      text: actualaddress.toString(),
                                      fontsize: 13,
                                      fontcolor: textcolorgrey,
                                      weight: FontWeight.w400,
                                      max_lines: 3,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Column(
                                children: [
                                  showImage != true
                                      ? Row(
                                          children: [
                                            DottedBorder(
                                                color: Color(0xffE5E5E5),
                                                //color of dotted/dash line
                                                strokeWidth: 1.5,
                                                //thickness of dash/dots
                                                dashPattern: [8, 4],
                                                child: Container(
                                                  height: height * 0.20,
                                                  width: width * 0.42,
                                                  color: Color(0xffE5E5E5),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _uploadImg(true);
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            "assets/icons/camera.png",
                                                            scale: 3.5,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.02,
                                                          ),
                                                          VariableText(
                                                            text: "Camera",
                                                            fontsize: 13,
                                                            weight:
                                                                FontWeight.w400,
                                                            fontcolor:
                                                                textcolorblack,
                                                          ),
                                                        ],
                                                      )),
                                                )),
                                            Spacer(),
                                            //dash patterns, 10 is dash width, 6 is space width
                                            DottedBorder(
                                                color: Color(0xffE5E5E5),
                                                //color of dotted/dash line
                                                strokeWidth: 1.5,
                                                //thickness of dash/dots
                                                dashPattern: [8, 4],
                                                child: Container(
                                                  height: height * 0.20,
                                                  width: width * 0.42,
                                                  color: Color(0xffE5E5E5),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        _uploadImg(false);
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            "assets/icons/gallery.png",
                                                            scale: 3.5,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.02,
                                                          ),
                                                          VariableText(
                                                            text: "Gallery",
                                                            fontsize: 13,
                                                            weight:
                                                                FontWeight.w400,
                                                            fontcolor:
                                                                textcolorblack,
                                                          ),
                                                        ],
                                                      )),
                                                )),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: height * 0.20,
                                                width: width,
                                                color: Colors.white,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      showImage = false;
                                                      image = null;
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      ShaderMask(
                                                        shaderCallback:
                                                            (Rect bounds) {
                                                          return LinearGradient(
                                                            // center: Alignment.topLeft,
                                                            //radius: 1.0,
                                                            colors: <Color>[
                                                              Colors.grey,
                                                              Colors.grey
                                                            ],
                                                          ).createShader(
                                                              bounds);
                                                        },
                                                        child: Image.file(
                                                          image,
                                                          height: height * 0.20,
                                                          width: width,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.5),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                          ),
                                                          child: Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),

                              ///new
                              SizedBox(
                                height: height * 0.03,
                              ),
                              VariableText(
                                text: 'Address',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Stack(
                                children: [
                                  RectangluartextFeild(
                                    hinttext: updateLocation
                                        ? actualaddress.toString()
                                        : apiAddress,
                                    //cont: currentlocation,
                                    enable: false,
                                    //onChanged: enableBtn(email.text),
                                    keytype: TextInputType.text,
                                    textlength: 25,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        //child: Image.asset('assets/icons/locationpin.png',scale: 3.5,),
                                        child: actualaddress == null
                                            ? Image.asset(
                                          'assets/icons/locationpin.png',
                                          scale: 3.5,
                                        )
                                            : Container(),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              VariableText(
                                text: 'Owner Name',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              RectangluartextFeild(
                                hinttext: name.text,
                                cont: name,
                                //onChanged: enableBtn(email.text),
                                keytype: TextInputType.text,
                                textlength: 25,
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              VariableText(
                                text: 'Phone No. #',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              RectangluartextFeild(
                                //showprefix: true,
                                hinttext: phoneno.text,
                                cont: phoneno,
                                //onChanged: enableBtn(email.text),
                                keytype: TextInputType.phone,
                                textlength: 25,
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),

                              ///get city
                              VariableText(
                                text: 'City',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffF4F4F4),
                                    border:
                                        Border.all(color: Color(0xffEEEEEE))),
                                height: height * 0.065,
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEEEEEE))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      contentPadding: EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 5,
                                          right: 10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<City>(
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text("Select your city",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(
                                                        0xffB2B2B2,
                                                      ))),
                                            ),
                                            value: sel_cities,
                                            isExpanded: true,
                                            onTap: () {},
                                            onChanged: (city) async {
                                              setState(() {
                                                sel_cities = city;
                                                print("Selected city is: " +
                                                    sel_cities.cityName
                                                        .toString() +
                                                    " " +
                                                    sel_cities.cityCode
                                                        .toString());
                                              });
                                              if (areas != null) {
                                                hasArea = true;
                                                areas.clear();
                                                sel_areas = null;
                                              }

                                              List<Area> a = await getAreas(
                                                  sel_cities.cityCode
                                                      .toString());
                                              setState(() {
                                                //areas = a;
                                                print("area list is" +
                                                    areas.toString());
                                                if (areas != null) {
                                                  hasArea = true;
                                                } else {
                                                  hasArea = false;
                                                }
                                              });
                                            },
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(
                                                  0xffC5C5C5,
                                                )),
                                            items: cities
                                                .map<DropdownMenuItem<City>>(
                                                    (City item) {
                                              return DropdownMenuItem<City>(
                                                value: item,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: VariableText(
                                                        text: item.cityName ??
                                                            'Not Found',
                                                        fontsize: 13,
                                                        weight: FontWeight.w400,
                                                        fontcolor:
                                                            textcolorblack)),
                                              );
                                            }).toList()))),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),

                              ///get area
                              VariableText(
                                text: 'Area',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffF4F4F4),
                                    border:
                                        Border.all(color: Color(0xffEEEEEE))),
                                height: height * 0.065,
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEEEEEE))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      contentPadding: EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 5,
                                          right: 10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<Area>(
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text("Select your area",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(
                                                        0xffB2B2B2,
                                                      ))),
                                            ),
                                            value: sel_areas,
                                            isExpanded: true,
                                            onTap: () {},
                                            onChanged: (area) async {
                                              setState(() {

                                                sel_areas = area;
                                                print("Selected area is: "+sel_areas.areaCode.toString());
                                                print("area is: "+area.toString());
                                              });
                                            },
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(
                                                  0xffC5C5C5,
                                                )),
                                            items: hasArea
                                                ? areas.map<
                                                        DropdownMenuItem<Area>>(
                                                    (Area item) {
                                                    return DropdownMenuItem<Area>(
                                                      value: item,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: VariableText(
                                                            text:
                                                                item.areaName ??
                                                                    'Not Found',
                                                            fontsize: 13,
                                                            weight:
                                                                FontWeight.w400,
                                                            fontcolor:
                                                                textcolorblack),
                                                      ),
                                                    );
                                                  }).toList()
                                                : []))),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),

                              ///get partycategory
                              VariableText(
                                text: 'PartyCategories',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffF4F4F4),
                                    border:
                                        Border.all(color: Color(0xffEEEEEE))),
                                height: height * 0.065,
                                child: InputDecorator(
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffEEEEEE))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      contentPadding: EdgeInsets.only(
                                          top: 0,
                                          bottom: 0,
                                          left: 5,
                                          right: 10),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<PartyCategories>(
                                            icon: Icon(Icons.arrow_drop_down),
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  "Select your party categories",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(
                                                        0xffB2B2B2,
                                                      ))),
                                            ),
                                            value: sel_party_categories,
                                            isExpanded: true,
                                            onTap: () {},
                                            onChanged: (partycategory) async {
                                              setState(() {
                                                sel_party_categories =
                                                    partycategory;

                                                print("Selected cat is: " +
                                                    sel_party_categories
                                                        .partyCategoriesCode
                                                        .toString() +
                                                    " " +
                                                    sel_party_categories
                                                        .partyCategoriesName);
                                              });
                                            },
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(
                                                  0xffC5C5C5,
                                                )),
                                            items: party_categories.map<
                                                    DropdownMenuItem<
                                                        PartyCategories>>(
                                                (PartyCategories item) {
                                              return DropdownMenuItem<
                                                  PartyCategories>(
                                                value: item,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: VariableText(
                                                      text:
                                                          item.partyCategoriesName ??
                                                              'Not Found',
                                                      fontsize: 13,
                                                      weight: FontWeight.w400,
                                                      fontcolor:
                                                          textcolorblack),
                                                ),
                                              );
                                            }).toList()))),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),

                              VariableText(
                                text: 'Shop Name',
                                fontsize: 12,
                                weight: FontWeight.w500,
                                fontcolor: textcolorblack,
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              RectangluartextFeild(
                                hinttext: shopname.text,
                                cont: shopname,
                                //onChanged: enableBtn(email.text),
                                keytype: TextInputType.text,
                                textlength: 25,
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),

                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (checkbox == true) {
                                        setState(() {
                                          checkbox = false;
                                        });
                                      } else if (checkbox == false) {
                                        setState(() {
                                          checkbox = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: height * 0.025,
                                      width: height * 0.025,
                                      decoration: BoxDecoration(
                                          color: checkbox == true
                                              ? themeColor1
                                              : Colors.white,
                                          border: Border.all(
                                              color: checkbox == true
                                                  ? themeColor1
                                                  : Color(0xFFB7B7B7)),
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: Center(
                                          child: Icon(Icons.check,
                                              size: 15, color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: height * 0.025,
                                  ),
                                  VariableText(
                                    text: "Child Contact Details (Optional)",
                                    fontsize: 13,
                                    fontcolor: textcolorlightgrey2,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              checkbox == true
                                  ? Container(
                                      height: height * 0.28,
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: Color(0xffF4F4F4),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: Color(0xffEEEEEE))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: height * 0.03,
                                            ),
                                            VariableText(
                                              text: 'Second Name',
                                              fontsize: 12,
                                              weight: FontWeight.w500,
                                              fontcolor: textcolorblack,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            RectangluartextFeild(
                                              containerColor: Color(0xffE5E5E5),
                                              hinttext: secondname.text,
                                              cont: secondname,
                                              //onChanged: enableBtn(email.text),
                                              keytype: TextInputType.text,
                                              textlength: 25,

                                              enableborder: false,
                                            ),
                                            SizedBox(
                                              height: height * 0.03,
                                            ),
                                            VariableText(
                                              text: 'Second Phone No.#',
                                              fontsize: 12,
                                              weight: FontWeight.w500,
                                              fontcolor: textcolorblack,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            RectangluartextFeild(
                                              enableborder: false,
                                              hinttext: secondphoneno.text,
                                              cont: secondphoneno,

                                              containerColor: Color(0xffE5E5E5),
                                              //onChanged: enableBtn(email.text),
                                              keytype: TextInputType.number,
                                              textlength: 25,
                                            ),
                                            SizedBox(
                                              height: height * 0.03,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              // if(userDetails.editable != null)
                              InkWell(
                                onTap: () {
                                  if (userDetails.editable == 'Y') editShopNew().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen())));
                                },
                                child: Container(
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                    color: userDetails.editable == 'Y'
                                        ? themeColor1
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: VariableText(
                                      text: 'Edit  Shop',
                                      weight: FontWeight.w700,
                                      fontsize: 16,
                                      fontcolor: themeColor2,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                            ]),
                      ),
                    ],
                  ))),
      ],
    );
  }

  Future<void> editShopNew() async {
    setLoading(true);
    if(image != null){
      var tempImage = await MultipartFile.fromFile(image.path,
          filename: "${widget.shopData.customerCode}-${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}",
          contentType: new MediaType('image', 'jpg'));
      print(tempImage.filename);
      postImage(tempImage);
    }else{
      editShop('');
    }
  }

  Future<void> editShop(String imageUrl) async {
    try {
      var response = await OnlineDataBase.editShop(
          customerCode: widget.shopData.customerCode,
          imageUrl: imageUrl,
          long: widget.long.toString(),
          lat: widget.lat.toString(),
          address: updateLocation ? actualaddress.toString() : apiAddress,
          customerName: name.text,
          customerName2:
              secondname.text.toString() == "NULL" ? '' : secondname.text,
          customerPhoneNo: phoneno.text,
          CustomerPhoneNo2:
              secondphoneno.text.toString() == "NULL" ? '' : '+92'+secondphoneno.text,
          shopname: shopname.text,
          partyCategory: sel_party_categories == null
              ? widget.shopData.customerCatCode
              : sel_party_categories.toString(),
          area: sel_areas == null
              ? widget.shopData.customerAreaCode
              : sel_areas.toString(),
          city: sel_cities == null
              ? widget.shopData.customerCityCode
              : sel_cities.toString()).catchError((e)=>Fluttertoast.showToast(
          msg: "Error: " +e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0));
      print("Response is: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        sucessfullyEditShop();
      } else {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      print("exception is " + e.toString());
    }
  }

  void postImage(var image) async {
      try {
        var response = await OnlineDataBase.uploadImage(
          type: 'customer',
          image: image
        );
        if(response){
          setLoading(false);
          print("Success");
          String imageUrl = 'https://suqexpress.com/assets/images/customer/${image.filename}';
          editShop(imageUrl);
        }else{
          setLoading(false);
          print("failed");
        }

      } catch (e, stack) {
        setLoading(false);
        print('exception is: ' + e.toString());
        setLoading(false);
      }
  }

  sucessfullyEditShop() {
    setLoading(false);
    Fluttertoast.showToast(
        msg: "Shop Edited Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
   //Navigator.push(context, SwipeLeftAnimationRoute(widget: MainMenuScreen()));
  }

  bool setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}

///old ui
/*class EditShopScreen extends StatefulWidget {
  var lat, long; 
  var locationdata;

  CustomerModel shopData;
  File _image1;


  EditShopScreen({this.lat, this.long,this.shopData,this.locationdata});

  @override
  _EditShopScreenState createState() => _EditShopScreenState();
}

class _EditShopScreenState extends State<EditShopScreen> {
  bool showImage = false;
  List edit_image = [];
  var actualaddress="Searching....";
  String base64Image;
  File image;
  bool isLoading=false;
  bool updateLocation=false;
  String apiAddress;
  String CustomerId;
  bool hasArea = false;
  bool hasPartyCategory = false;
  bool hasPayTerm = false;
  bool hasunionCouncil = false;
  bool hascityMarket = false;

  bool _serviceEnabled=false;
  LocationData _locationData;
  Location location = new Location();
  Town sel_town;
  DateTime selectedDate = DateTime.now();
  bool checkbox=false;
  String formattedDate;
  TextEditingController name             ;
  TextEditingController secondname       ;
  TextEditingController phoneno          ;
  TextEditingController cnic             ;
  TextEditingController cnic_expairy_date;
  TextEditingController secondphoneno    ;
  TextEditingController address          ;
  TextEditingController email            ;
  TextEditingController currentlocation  ;
  TextEditingController shoptown         ;
  TextEditingController shopname         ;
  List<Town> townList=[];

  List<City> cities;
  City sel_cities;
  List<Area> areas;
  Area sel_areas;
  List<PartyCategories> party_categories;
  PartyCategories sel_party_categories;
  List<PayTerm> payTerm_categories;
  PayTerm sel_payTerm_categories;
  List<UnionCouncil> unioncouncil_categories;
  UnionCouncil sel_unioncouncil_categories;
  List<CityMarkets> citymarket_categories;
  CityMarkets sel_citymarket_categories;

@override
  initState()  {
    // TODO: implement initState
    super.initState();
    print("init call"+widget.shopData.customerContactNumber);
  name             = TextEditingController(text:widget.shopData.customerContactPersonName.toString());
  secondname       = TextEditingController(text:widget.shopData.customerContactPersonName2);
  phoneno          = TextEditingController(text:widget.shopData.customerContactNumber);
  cnic             = TextEditingController(text:widget.shopData.customerCnic);
  cnic_expairy_date= TextEditingController(text:widget.shopData.customerCnicExpiry);
  secondphoneno    = TextEditingController(text:widget.shopData.customerContactNumber2);
  address          = TextEditingController(text:widget.shopData.customerAddress);
  email            = TextEditingController(text: widget.shopData.customerEmail);
  shopname         = TextEditingController(text:widget.shopData.customerShopName);
    cities = [];
    areas = [];
    party_categories = [];
    payTerm_categories = [];
    unioncouncil_categories = [];
    citymarket_categories = [];
    checkLocation();
    initPage();
    getAllCities();
    getPayTermCategory();
    getPartyCategory();

  }
  checkLocation() async{
    if(widget.locationdata==null) {
      _serviceEnabled = await location.requestService();
    }
    else{
    }
    widget.locationdata= await location.getLocation();
    final coordinates = new Coordinates(widget.locationdata.latitude, widget.locationdata.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      actualaddress = addresses.first.addressLine;
    });
    print("address is"+actualaddress.toString());

  }
  Future<List<City>> getAllCities() async{
    List<City> tempCity = await OnlineDataBase.getAllCities();
    isLoading=false;
    setState(() {
      cities = tempCity;
    });

  }
  Future<List<Area>> getAreas(cityID) async{
    List<Area> tempArea = await OnlineDataBase.getAreaByCity(cityID);
    setState(() {
      areas = tempArea;
    });
  }
  Future<List<PartyCategories>> getPartyCategory() async{
    List<PartyCategories> tempPartyCategory = await OnlineDataBase.getPartyCategories();
    setState(() {
      party_categories = tempPartyCategory;
    });
  }
  Future<List<PayTerm>> getPayTermCategory() async{
    List<PayTerm> tempPayTerm = await OnlineDataBase.getPayTermCategories();
    setState(() {
      payTerm_categories = tempPayTerm;
    });
  }
  Future<List<UnionCouncil>> getUnionCouncilCategory() async{
    List<UnionCouncil> tempUnionCouncilCategory = await OnlineDataBase.getUnionCouncilCategories(cityCode: sel_cities.cityCode,areaCode: sel_areas.areaCode);
    setState(() {
      unioncouncil_categories = tempUnionCouncilCategory;
    });
  }
  Future<List<CityMarkets>> getCityMarketCategory() async{
    List<CityMarkets> tempCityMarketsCategory = await OnlineDataBase.getCityMarketCategories(cityCode: sel_cities.cityCode,areaCode: sel_areas.areaCode,ucCode: sel_unioncouncil_categories.UCCode);
    setState(() {
      citymarket_categories = tempCityMarketsCategory;
    });
  }
 initPage() async {
     apiAddress=widget.shopData.customerAddress.toString();
   final coordinates=new Coordinates(widget.lat, widget.long);
   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  // actualaddress = addresses.first.subLocality.toString()+" "+addresses.first.locality.toString();
actualaddress = addresses.first.addressLine;
print("data is"+actualaddress.toString());
   setState(() {

});
 }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return  Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1,// header background color
                //onPrimary: Colors.black, // header text color
                //onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeColor1, // button text color
                ),
              ),
            ),
            child: child,
          );}
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    print("selected date is"+selectedDate.toString());
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    formattedDate = dateFormat.format(selectedDate);
    print("selected date is"+formattedDate);
    cnic_expairy_date.text=formattedDate;



  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: themeColor2),
              elevation: 0.5,
              backgroundColor: themeColor1,
              title: VariableText(
                text: 'Edit Shop',
                fontsize: 16,
                fontcolor: themeColor2,
                weight: FontWeight.w600,
              ),
            ),
            body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: height*0.09,
                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                VariableText(
                                  text: 'Current Location',
                                  fontsize:15,fontcolor: textcolorblack,
                                  weight: FontWeight.w500,
                                  fontFamily: fontMedium,
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: (){

                                      if(updateLocation==false){
                                        setState(() {
                                          updateLocation=true;
                                        });
                                      }
                                      else{

                                          setState(() {
                                            updateLocation=false;
                                          });
                                      }
                                    },
                                    child: Image.asset('assets/icons/locationpin.png',scale: 3.5,)),
                              ],
                            ),
                            SizedBox(height: height*0.01,),

                            Container(
                              //color: Colors.red,
                              child: Wrap(
                                children: [
                                  VariableText(
                                    text: actualaddress.toString(),
                                    fontsize:13,fontcolor: textcolorgrey,
                                    weight: FontWeight.w400,
                                    max_lines: 3,
                                    textAlign: TextAlign.start,
                                    fontFamily: fontRegular,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
              padding: EdgeInsets.symmetric(horizontal: screenpadding),
              child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    SizedBox(
                      height: height * 0.03,
                    ),
                    Column(
                      children: [
                        showImage != true
                            ? Row(
                                children: [
                                  DottedBorder(
                                      color: Color(0xffE5E5E5),
                                      //color of dotted/dash line
                                      strokeWidth: 1.5,
                                      //thickness of dash/dots
                                      dashPattern: [8, 4],
                                      child: Container(
                                        height: height * 0.20,
                                        width: width * 0.42,
                                        color: Color(0xffE5E5E5),
                                        child: GestureDetector(
                                            onTap: () {
                                              //_imgFromGallery("camera");
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/camera.png",
                                                  scale: 3.5,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                ),
                                                VariableText(
                                                  text: "Camera",
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontcolor: textcolorblack,
                                                  fontFamily: fontRegular,
                                                ),
                                              ],
                                            )),
                                      )),
                                  Spacer(),
                                  //dash patterns, 10 is dash width, 6 is space width
                                  DottedBorder(
                                      color: Color(0xffE5E5E5),
                                      //color of dotted/dash line
                                      strokeWidth: 1.5,
                                      //thickness of dash/dots
                                      dashPattern: [8, 4],
                                      child: Container(
                                        height: height * 0.20,
                                        width: width * 0.42,
                                        color: Color(0xffE5E5E5),
                                        child: GestureDetector(
                                            onTap: () {
                                             // _imgFromGallery("gallery");
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/gallery.png",
                                                  scale: 3.5,
                                                ),
                                                SizedBox(
                                                  height: height * 0.02,
                                                ),
                                                VariableText(
                                                  text: "Gallery",
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontcolor: textcolorblack,
                                                  fontFamily: fontRegular,
                                                ),
                                              ],
                                            )),
                                      )),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: height * 0.20,
                                      width: width,
                                      color: Colors.white,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //widget._image1=null;
                                            showImage = false;
                                          });
                                        },
                                        child: Stack(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  // center: Alignment.topLeft,
                                                  //radius: 1.0,
                                                  colors: <Color>[
                                                    Colors.grey,
                                                    Colors.grey
                                                  ],
                                                ).createShader(bounds);
                                              },
                                              child: Image.file(
                                                widget._image1,
                                                height: height * 0.20,
                                                width: width,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Align(
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                        ///new
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Owner Name',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RectangluartextFeild(
                          hinttext:name.text,
                          cont: name,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.text,
                          textlength: 25,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Phone No. #',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RectangluartextFeildWithPrefix(
                          showprefix: true,
                          hinttext: phoneno.text,
                          cont: phoneno,

                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.number,
                          textlength: 25,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Email',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RectangluartextFeild(
                          hinttext:email.text,
                          cont: email,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.emailAddress,
                          textlength: 25,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),

                        VariableText(
                          text: 'Cnic',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RectangluartextFeild(
                          hinttext: cnic.text,
                          cont: cnic,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.number,
                          textlength: 25,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Cnic Expiry Date',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Stack(
                          children: [
                            RectangluartextFeild(
                              hinttext: cnic_expairy_date.text,
                              cont: cnic_expairy_date,
                              //onChanged: enableBtn(email.text),
                              keytype: TextInputType.number,
                              textlength: 25,
                              enable: false,
                            ),
                            InkWell(
                              onTap: (){
                                _selectDate(context);
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  //color: Colors.red,
                                  child: Icon(Icons.calendar_today_outlined),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),


                        ///get city
                        VariableText(
                          text: 'City',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<City>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your city", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_cities,
                                      isExpanded: true,
                                      onTap: (){
                                      },
                                      onChanged: (city) async {
                                        setState(() {
                                          sel_cities=city;
                                          print("Selected city is: "+sel_cities.cityName.toString()+" "+sel_cities.cityCode.toString());
                                        });
                                        if(areas!=null){
                                          hasArea = true;  areas.clear();
                                          sel_areas=null;  }

                                        List<Area> a = await getAreas(sel_cities.cityCode.toString());
                                        setState(() {
                                          //areas = a;
                                          print("area list is"+areas.toString());
                                          if(areas!=null){
                                            hasArea = true;
                                          }
                                          else{
                                            hasArea=false;
                                          }
                                        });
                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:
                                      cities.map<DropdownMenuItem<City>>((City item) {
                                        return DropdownMenuItem<City>(
                                          value: item,
                                          child: Padding(
                                              padding: const EdgeInsets.only(left:8.0),
                                              child: VariableText(
                                                  text: item.cityName??'Not Found',
                                                  fontsize: 13,
                                                  weight: FontWeight.w400,
                                                  fontFamily: fontLight,
                                                  fontcolor: textcolorblack

                                              )


                                          ),
                                        );
                                      }).toList()
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ///get area
                        VariableText(
                          text: 'Area',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<Area>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your area", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_areas,
                                      isExpanded: true,
                                      onTap: (){

                                      },
                                      onChanged: (area) async {
                                        setState(() {
                                          sel_areas=area;

                                          //print("Selected area is: "+sel_areas.areaCode.toString());
                                        });
                                        if(unioncouncil_categories!=null){
                                          unioncouncil_categories.clear();
                                          sel_unioncouncil_categories=null; }
                                        List<UnionCouncil> a = await getUnionCouncilCategory();
                                        setState(() {
                                          //print("area list is"+payTerm_categories.toString());
                                          if(unioncouncil_categories!=null){
                                            hasunionCouncil = true;
                                          }
                                          else{
                                            hasunionCouncil=false;
                                          }
                                        });

                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:hasArea ?
                                      areas.map<DropdownMenuItem<Area>>((Area item) {
                                        return DropdownMenuItem<Area>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: VariableText(
                                                text: item.areaName??'Not Found',
                                                fontsize: 13,
                                                weight: FontWeight.w400,
                                                fontFamily: fontLight,
                                                fontcolor: textcolorblack
                                            ),
                                          ),
                                        );
                                      }).toList():[]
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ///get union council
                        VariableText(
                          text: 'Union Councils',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<UnionCouncil>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your union councils", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_unioncouncil_categories,
                                      isExpanded: true,
                                      onTap: (){

                                      },
                                      onChanged: (uc) async {
                                        setState(() {
                                          sel_unioncouncil_categories=uc;
                                          //print("Selected area is: "+sel_unioncouncil_categories.UCCode.toString());

                                        });
                                        if(citymarket_categories!=null){
                                          citymarket_categories.clear();
                                          sel_citymarket_categories=null; }

                                        List<CityMarkets> a = await getCityMarketCategory();
                                        setState(() {
                                          //print("area list is"+payTerm_categories.toString());
                                          if(citymarket_categories!=null){
                                            hascityMarket = true;
                                          }
                                          else{
                                            hascityMarket=false;
                                          }
                                        });
                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:hasunionCouncil?
                                      unioncouncil_categories.map<DropdownMenuItem<UnionCouncil>>((UnionCouncil item) {
                                        return DropdownMenuItem<UnionCouncil>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: VariableText(
                                                text: item.UCName??'Not Found',
                                                fontsize: 13,
                                                weight: FontWeight.w400,
                                                fontFamily: fontLight,
                                                fontcolor: textcolorblack
                                            ),
                                          ),
                                        );
                                      }).toList():[]
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ///get city markets
                        VariableText(
                          text: 'City Markets',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<CityMarkets>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your city markets", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_citymarket_categories,
                                      isExpanded: true,
                                      onTap: (){

                                      },
                                      onChanged: (cm){
                                        setState(() {
                                          sel_citymarket_categories=cm;

                                          //  print("Selected area is: "+sel_town.id.toString()+" "+sel_town.name);
                                        });
                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:
                                      hascityMarket?  citymarket_categories.map<DropdownMenuItem<CityMarkets>>((CityMarkets item) {
                                        return DropdownMenuItem<CityMarkets>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: VariableText(
                                                text: item.marketName??'Not Found',
                                                fontsize: 13,
                                                weight: FontWeight.w400,
                                                fontFamily: fontLight,
                                                fontcolor: textcolorblack

                                            ),
                                          ),
                                        );
                                      }).toList():[]
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ///get partycategory
                        VariableText(
                          text: 'PartyCategories',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<PartyCategories>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your party categories", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_party_categories,
                                      isExpanded: true,
                                      onTap: (){

                                      },
                                      onChanged: (partycategory) async {
                                        setState(() {
                                          sel_party_categories=partycategory;

                                          print("Selected cat is: "+sel_party_categories.partyCategoriesCode.toString()+" "+sel_party_categories.partyCategoriesName);
                                        });


                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:
                                      party_categories.map<DropdownMenuItem<PartyCategories>>((PartyCategories item) {
                                        return DropdownMenuItem<PartyCategories>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: VariableText(
                                                text: item.partyCategoriesName??'Not Found',
                                                fontsize: 13,
                                                weight: FontWeight.w400,
                                                fontFamily: fontLight,
                                                fontcolor: textcolorblack

                                            ),
                                          ),
                                        );
                                      }).toList()
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        ///get payterm
                        VariableText(
                          text: 'Pay Term',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color(0xffF4F4F4),
                              border: Border.all(color: Color(0xffEEEEEE))
                          ),
                          height: height * 0.065,
                          child: InputDecorator(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffEEEEEE))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),

                                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 10),
                              ),

                              child:
                              DropdownButtonHideUnderline(
                                  child: DropdownButton<PayTerm>(
                                      icon:Icon(Icons.arrow_drop_down),
                                      hint: Padding(

                                        padding: const EdgeInsets.only(left:8.0),
                                        child:
                                        Text("Select your pay term", style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: fontLight,
                                            color: Color(
                                              0xffB2B2B2,
                                            ))),
                                      ),
                                      value: sel_payTerm_categories,
                                      isExpanded: true,
                                      onTap: (){

                                      },
                                      onChanged: (payterm) async {
                                        setState(() {
                                          sel_payTerm_categories=payterm;

                                          //  print("Selected area is: "+sel_town.id.toString()+" "+sel_town.name);
                                        });


                                      },
                                      style: TextStyle(fontSize: 14,
                                          color: Color(0xffC5C5C5, )),
                                      items:
                                      payTerm_categories.map<DropdownMenuItem<PayTerm>>((PayTerm item) {
                                        return DropdownMenuItem<PayTerm>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: VariableText(
                                                text: item.payTermName??'Not Found',
                                                fontsize: 13,
                                                weight: FontWeight.w400,
                                                fontFamily: fontLight,
                                                fontcolor: textcolorblack

                                            ),
                                          ),
                                        );
                                      }).toList()
                                  ))),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Address',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Stack(
                          children: [
                            RectangluartextFeild(

                              hinttext: updateLocation?actualaddress.toString():apiAddress,
                              //cont: currentlocation,
                              enable: false,
                              //onChanged: enableBtn(email.text),
                              keytype: TextInputType.text,
                              textlength: 25,

                            ),
                            Align(
                                alignment:Alignment.centerRight,
                                child:Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  //child: Image.asset('assets/icons/locationpin.png',scale: 3.5,),
                                  child: actualaddress==null?Image.asset('assets/icons/locationpin.png',scale: 3.5,):Container(),
                                )

                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        VariableText(
                          text: 'Shop Name',
                          fontsize:12,
                          fontFamily: fontMedium,
                          weight: FontWeight.w500,
                          fontcolor: textcolorblack,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        RectangluartextFeild(
                          hinttext: shopname.text,
                          cont:shopname,
                          //onChanged: enableBtn(email.text),
                          keytype: TextInputType.text,
                          textlength: 25,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),

                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (checkbox == true) {
                                  setState(() {
                                    checkbox = false;
                                  });
                                } else if (checkbox == false) {
                                  setState(() {
                                    checkbox = true;
                                  });
                                }
                              },
                              child: Container(
                                height: height * 0.025,
                                width: height * 0.025,
                                decoration: BoxDecoration(
                                    color: checkbox == true ? themeColor1 : Colors.white,
                                    border: Border.all(
                                        color: checkbox == true
                                            ? themeColor1
                                            : Color(0xFFB7B7B7)),
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                    child:
                                    Icon(Icons.check, size: 15, color: Colors.white)),
                              ),
                            ),
                            SizedBox(width: height*0.025,),
                            VariableText(
                              text: "Child Contact Details (Optional)",
                              fontsize: 13,
                              fontcolor: textcolorlightgrey2,
                              fontFamily: fontRegular,
                            ),


                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        checkbox == true?Container(
                          height: height*0.28,
                          width: width,
                          decoration: BoxDecoration(
                              color: Color(0xffF4F4F4),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Color(0xffEEEEEE))

                          ),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                VariableText(
                                  text: 'Second Name',
                                  fontsize:12,
                                  fontFamily: fontMedium,
                                  weight: FontWeight.w500,
                                  fontcolor: textcolorblack,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                RectangluartextFeild(
                                  containerColor:Color(0xffE5E5E5),
                                  hinttext: secondname.text,
                                  cont: secondname,
                                  //onChanged: enableBtn(email.text),
                                  keytype: TextInputType.text,
                                  textlength: 25,

                                  enableborder: false,
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                VariableText(
                                  text: 'Second Phone No.#',
                                  fontsize:12,
                                  fontFamily: fontMedium,
                                  weight: FontWeight.w500,
                                  fontcolor: textcolorblack,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                RectangluartextFeild(
                                  enableborder: false,
                                  hinttext:secondphoneno.text,
                                  cont: secondphoneno,


                                  containerColor:Color(0xffE5E5E5),
                                  //onChanged: enableBtn(email.text),
                                  keytype: TextInputType.number,
                                  textlength: 25,
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                              ],
                            ),
                          ),


                        ):Container(
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),

                        InkWell(
                          onTap: (){
                            editShop();
                          },
                          child: Container(
                            height: height*0.06,
                            decoration: BoxDecoration(
                              color: themeColor1,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:   Center(
                              child: VariableText(
                                text: 'Edit  Shop',
                                weight: FontWeight.w700,
                                fontsize: 16,
                                fontFamily: fontRegular,
                                fontcolor: themeColor2,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
              ]),
            ),

                  ],
                ))),
        isLoading?Positioned.fill(child:ProcessLoading()):Container(),
      ],
    );
  }
  Future<void> editShop()  async {

    setLoading(true);
    try{
      var response =await OnlineDataBase.editShop(customerCode: widget.shopData.customerCode,long: widget.long.toString(),lat: widget.lat.toString(),address:updateLocation?actualaddress.toString():apiAddress,customerName: name.text,
      customerName2: secondname.text.toString()=="NULL"?'': secondname.text,customerPhoneNo: phoneno.text,CustomerPhoneNo2:secondphoneno.text.toString()=="NULL"?'':secondphoneno.text,
      email: email.text,Cnic: cnic.text,CnicExpiry: cnic_expairy_date.text.toString()=="NULL"?'':cnic_expairy_date.text,shopname: shopname.text,payterm: sel_payTerm_categories==null?widget.shopData.customerTermCode:sel_payTerm_categories.toString(),partyCategory: sel_party_categories==null?widget.shopData.customerCatCode:sel_party_categories.toString(),
      area: sel_areas==null?widget.shopData.customerAreaCode:sel_areas.toString(),market: sel_citymarket_categories==null?widget.shopData.customerMarketCode:sel_citymarket_categories.toString(),city: sel_cities==null?widget.shopData.customerCityCode:sel_cities.toString(),uc: sel_unioncouncil_categories==null?widget.shopData.customerUCCode:sel_unioncouncil_categories.toString());
      print("Responsess is" + response.statusCode.toString());

    if(response.statusCode==200){
     showImage? postImage(customerId: widget.shopData.customerCode,):sucessfullyEditShop();
       //postImage(customerId: widget.shopData.customerCode,);
    }
    else{
      Fluttertoast.showToast(
          msg: "Something went wrong try again letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
      setLoading(false);
    }
    }
    catch(e){
      setLoading(false);
      print("exception is "+e.toString());
    }

  }
  void postImage({String customerId}) async{
    try {
      setLoading(true);
      var response =await  OnlineDataBase.postImage(customerCode: customerId,source:'CUSTOMER',apiName: 'posteditshop',imageFor: 'PAGETITLE',imageBinary:image.path );
      print("post image Response code is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print("Response isdf" + data.toString());
        sucessfullyEditShop();


      }
      else if(response.statusCode == 401){
        setLoading(false);
      }
      else {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        setLoading(false);
        Fluttertoast.showToast(
          // msg: "${data.toString()}",
            msg: "Internet issue",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);

      }
    } catch (e, stack) {
      print('exception is'+e.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong try again letter",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  sucessfullyEditShop(){
    Fluttertoast.showToast(
        msg: "Shop Edited Successfully",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
    );     setLoading(false);
    Navigator.push(
        context, SwipeLeftAnimationRoute(widget:  MainMenuScreen()));
  }
  bool setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }
}*/
