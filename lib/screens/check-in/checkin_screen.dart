import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/model/product_model.dart';
import 'package:skr_delivery/model/retrun_cart_model.dart';
import 'package:skr_delivery/screens/DeliveryScreen/delivery_screen.dart';
import 'package:skr_delivery/screens/DeliveryScreen/succesflly_delieverd_order_screen.dart';
import 'package:skr_delivery/screens/PaymentScreen/payment_screen.dart';
import 'package:skr_delivery/screens/RetrunScreen/reurn_screen.dart';
import 'package:skr_delivery/screens/check-in/wallet_card.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';

import '../../ApiCode/online_database.dart';
import 'customer_info_card.dart';

class CheckIn extends StatefulWidget {
  CheckIn({this.code,this.name,this.image,this.customerData});
  final code;
  final name;
  final image;
  final customerData;
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
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
  void getCustomerTransactionData() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.getTranactionDetails(
          customerCode:widget.code );
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
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  void getAllProductData() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.getAllPrdouct();
      //print("getAllProduct: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        product = [];
        // print("Response is" + data.toString());
        var datalist = data['results'];
        print("data is " + datalist.toString());
        if (datalist != null) {
          // if(datalist!=null) {
          for (var item in datalist) {
            //   if(item['PRICE'] != null){
            /*   ProductModel productt = ProductModel(
                  price: int.parse(item['SELLING_PRICE'].toStringAsFixed(0)),
                  name:item['PRODUCT'],
                  productCode:item['PROD_CODE']);*/
            product.add(ProductModel.fromJson(item));
            // product.add(item);
            //   }
            /*        if(item['SELLING_PRICE'] != null){
              ProductModel productt = ProductModel(
                  price: int.parse(item['SELLING_PRICE'].toStringAsFixed(0)),
                  name:item['PRODUCT'],
                  productCode:item['PROD_CODE']);

              product.add(productt);
            }*/
            /*    else{
              continue;
            }*/
          }
          print("new data is " + product.length.toString());
          setLoading(false);
        }
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
      print('exception is' + e.toString() + stack.toString());
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
    getCustomerTransactionData();
    getAllProductData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var returncartData =
        Provider.of<RetrunCartModel>(context, listen: true).returncartItemName;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Check-In"),
        backgroundColor: themeColor1,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomerInfo(height: height,code: widget.code,name: widget.name,image:widget.image,lat: "123",long: "456",location: widget.customerData.customerAddress.toString(),shopDetails: widget.customerData,),
              CustomerWallet(height: height, f: f,walletCapacity: walletCapacity,useBalance: usedBalance,availableBalances: availableBalance,),
              SizedBox(height: 20,),
              CheckInButton(image: "assets/icons/delivery.png",text: "Delivery",onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryScreen(long: 123.0,lat: 456.0,shopDetails: widget.customerData,))),),
              CheckInButton(image: "assets/icons/payment.png",text: "Payment",onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen(lat: "123",long: "456",customerData: widget.customerData,))),),
              CheckInButton(image: "assets/icons/exchange.png",text: "Return",onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnScreen(returncartData:returncartData,shopDetails: widget.customerData,lat: 123.0,long: 456.0,product: product,))),),
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




