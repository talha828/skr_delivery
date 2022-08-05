import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/model/cart_model.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/product_model.dart';
import 'package:skr_delivery/model/retrun_cart_model.dart';
import 'package:skr_delivery/screens/DeliveryScreen/delivery_screen.dart';
import 'package:skr_delivery/screens/check-in/wallet_card.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;

import '../../ApiCode/online_database.dart';
import 'customer_info_card.dart';

class CheckIn extends StatefulWidget {
  CheckIn({this.customerData});
  CustomerModel customerData;
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  Coordinates userLatLng;
  loc.Location location = new loc.Location();
  CustomerModel userDetails;
  bool isLoading=true;
  var f = NumberFormat("###,###.0#", "en_US");
  double walletCapacity = 0;
  double usedBalance = 0;
  double availableBalance = 0.0;
  List<ProductModel> product = [];
  // set loading
  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  getUser() async {
    setLoading(true);
    var response =
    await OnlineDataBase.getSingleCustomer(widget.customerData.customerCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data.toString());
      userDetails = CustomerModel.fromModel(data['results'][0]);
      setLoading(false);
    } else {
      print("User not found!!!!!");
      setLoading(false);
    }
  }
  void getCustomerTransactionData() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.getTranactionDetails(
          customerCode:widget.customerData.customerCode );
      //print("Response is: "+response.statusCode.toString()+widget.shopDetails.customerCode );
      print("getTransactionDetails: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        // print("data is"+data.toString());
        var datalist = data['results'];
        walletCapacity =
            double.parse(datalist[0]['CREDIT_LIMIT'].toString()) ==0.0?0:double.parse(datalist[0]['CREDIT_LIMIT'].toString()) ;
        usedBalance = double.parse(datalist[0]['BALANCE'].toString()) == 0.0?0:double.parse(datalist[0]['BALANCE'].toString()) ;
        availableBalance = walletCapacity - usedBalance;
        setLoading(false);
      } else {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Something went wrong try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString());
      setLoading(false);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    getUser();
    getLocation();
    getCustomerTransactionData();
    super.initState();
  }
  void getLocation() async{
    var _location = await location.getLocation();
    userLatLng = Coordinates(_location.latitude, _location.longitude);
    print("userLatLng: " + userLatLng.toString());
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var returncartData =
        Provider.of<RetrunCartModel>(context, listen: true).returncartItemName;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,),onPressed: ()=>Navigator.pop(context)),
        title: Text("Check-In"),
        backgroundColor: themeColor1,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomerInfo(height: height,code: widget.customerData.customerCode,name: widget.customerData.customerShopName,image:"hh",lat: "123",long: "456",location: widget.customerData.customerAddress.toString(),shopDetails: widget.customerData,),
              CustomerWallet(height: height, f: f,walletCapacity: walletCapacity,useBalance: usedBalance,availableBalances: availableBalance,),
              SizedBox(height: 20,),
              CheckInButton(image: "assets/icons/delivery.png",text: "Delivery",onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryScreen(long:userLatLng.longitude ,lat:userLatLng.latitude,shopDetails: userDetails,))),),
              CheckInButton(image: "assets/icons/payment.png",text: "Payment",onTap: ()=>
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                title: 'No access',
                btnOkOnPress: () {},
              )..show(),
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen(long:userLatLng.longitude ,lat:userLatLng.latitude,customerData: widget.customerData,))),
              ),
              CheckInButton(image: "assets/icons/exchange.png",text: "Return",onTap: ()=>
              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.BOTTOMSLIDE,
                title: 'No access',
                btnOkOnPress: () {},
              )..show(),
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnScreen(returncartData:returncartData,shopDetails: widget.customerData,long:userLatLng.longitude ,lat:userLatLng.latitude,product: product,))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class CheckInButton extends StatelessWidget {
  CheckInButton({this.text,this.image,this.onTap,});
  final image;
  final text;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        color: themeColor1.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      child:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
            Container(
              child: Row(children: [
                Container(
                    child: Image.asset(image,width: 50,height: 50,)),
                SizedBox(width: 30,),
                Text(text,style: TextStyle(color: Colors.white,fontSize: 20),),
              ],),
            ),
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor:  themeColor1.withOpacity(0.75),
            child: Icon(Icons.arrow_forward_ios),
          ),
        ),
    ],) ,);
  }
}




