import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skr_delivery/screens/check-in/wallet_card.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';

import '../../online_database.dart';
import 'customer_info_card.dart';

class CheckIn extends StatefulWidget {
  CheckIn({this.code,this.name,this.image});
  final code;
  final name;
  final image;
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool isLoading=true;
  var f = NumberFormat("###,###.0#", "en_US");
  double walletCapacity = 0;
  double usedBalance = 0;
  double availableBalance = 0.0;
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

  @override
  void initState() {
    getCustomerTransactionData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Check-In"),
        backgroundColor: themeColor1,
      ),
      body: Container(
        child: Column(
          children: [
            CustomerInfo(height: height,code: widget.code,name: widget.name,image:widget.image ,),
            CustomerWallet(height: height, f: f,walletCapacity: walletCapacity,useBalance: usedBalance,availableBalances: availableBalance,),
            Container(child:Row(children: [
                    Image.asset("assets/icons/deliver.png")
            ],) ,),
          ],
        ),
      ),
    );
  }
}




