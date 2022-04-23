import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/screens/PaymentScreen/payment_using_checque.dart';
import 'package:skr_delivery/screens/PaymentScreen/pin_payment_screen.dart';
import 'package:skr_delivery/screens/PaymentScreen/sucessfully_recived_payment_screen.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/widget/common.dart';

import 'dart:math';

import 'package:skr_delivery/screens/widget/constant.dart';

import '../../ApiCode/online_database.dart';

class PaymentScreen extends StatefulWidget {
  final customerData;
  var lat,long;
  PaymentScreen({this.customerData,this.lat,this.long});
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic> paymentType = {
    "payment": [
      {
        'name': 'Cash',
        'image': 'assets/icons/cash.png',
        'image1': 'assets/icons/cash1.png'
      },
      {
        'name': 'Cheque',
        'image': 'assets/icons/cheque.png',
        'image1': 'assets/icons/cheque1.png'
      },
    ]
  };
  bool isLoading = false;
  bool selectPaymentMethod = false;
  bool showAmount = false;
  String totalAmount = '0';
  String Name = '';
  double sizedboxvalue = 0.02;
  bool checkbox = true;
  int count = 0;
  int delieveryFee = 0;
  int subtotal = 0;
  int paymenttypeSelected = -1;

  _onselected(int i) {
    setState(() {
      paymenttypeSelected = i;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalAmount = '0';
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
            elevation: 0.5,
            backgroundColor: themeColor1,
            title: VariableText(
              text: 'Payments Screen',
              fontsize: 18,
              fontcolor: Colors.white,
              weight: FontWeight.w600,
            ),
          ),
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: height * sizedboxvalue,
              ),
              paymentDetailsBlock(height, width),
            ]),
          ),
          /*   bottomNavigationBar: BottomAppBar(
              child: Container(
                height: height*0.13,
                color: themeColor2,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                  child: Column(

                    children: [
                      SizedBox(height: height*sizedboxvalue,),
                      Row(
                        children: [
                          VariableText(
                            text:'Total',
                            fontsize:13,fontcolor: textcolorblack,
                            weight: FontWeight.w700,
                            fontFamily: fontRegular,
                          ),
                          VariableText(
                            text:' (including all Tax)',
                            fontsize:13,fontcolor: textcolorgrey,
                            weight: FontWeight.w400,
                            fontFamily: fontRegular,
                          ),
                          Spacer(),
                          VariableText(
                            text:'Rs.$totalAmount',
                            fontsize:13,fontcolor: textcolorblack,
                            weight: FontWeight.w700,
                            fontFamily: fontRegular,
                          ),

                        ],
                      ),
                      SizedBox(height: height*sizedboxvalue/2,),
                      InkWell(
                        onTap: (){
                          //Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullyRecivePaymentScreen()));
                        },

                        child: Container(
                          height: height*0.06,
                          decoration: BoxDecoration(
                            color: themeColor1,
                            borderRadius: BorderRadius.circular(4),

                          ),

                          child:   Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                            child: Center(
                              child: VariableText(
                                text:selectPaymentMethod==true? 'PAY NOW':'SUBMIT',
                                weight: FontWeight.w700,
                                fontsize: 15,
                                fontFamily: fontMedium,
                                fontcolor: themeColor2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),*/
        ),
        isLoading ? Positioned.fill(child: loader()) : Container()
      ],
    );
  }

  Widget paymentDetailsBlock(double height, double width) {
    final userData = Provider.of<UserModel>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: VariableText(
            text: 'How would you like to pay?',
            fontsize: 20,
            fontcolor: textcolorblack,
            weight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: height * sizedboxvalue,
        ),
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: paymentType['payment'].length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      //   height: height*0.09,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: paymenttypeSelected == index
                                ? Color(0xffff0000).withOpacity(0.6)
                                : Color(0xffffffff).withOpacity(0.6)),
                        color: paymenttypeSelected == index
                            ? Color(0xb4fa7070).withOpacity(0.5)
                            : themeColor2,
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15 / 2),
                          child: InkWell(
                            onTap: () {
                              selectPaymentMethod = true;
                              print("print " + index.toString());
                              _onselected(index);
                              paymentType['payment'][index]['name'] == 'Cash'
                                  ? showDialog(
                                      height,
                                      width,
                                      paymentType['payment'][index],
                                      (amount, name) async {
                                        totalAmount = amount;
                                        Name = name;
                                        showAmount = true;
                                        setState(() {
                                        });
                                         if (validateFields()) {
                                           Navigator.of(context).pop();
                                           setLoading(true);
                                           List<String> tempContact = [];
                                           if(widget.customerData.customerContactNumber != null){
                                             tempContact.add(widget.customerData.customerContactNumber.substring(0, widget.customerData.customerContactNumber.length));
                                           }
                                           if(widget.customerData.customerContactNumber2 != null){
                                             tempContact.add(widget.customerData.customerContactNumber2);
                                           }else{
                                             //tempContact.add('+923340243440');
                                           }
                                           String msgPin = '';
                                           var rng = Random();
                                           for (var i = 0; i < 4; i++) {
                                             msgPin += rng.nextInt(9).toString();
                                           }
                                           print(msgPin);
                                           //String msgData = "آپ نے ہمارے نمائندے ${userData.userName} کو $totalAmount کا آرڈر دیا ہے۔\nشکریہ۔";
                                           String msgData = "آپ نے ہمارے نمائندے ${userData.userName} کو $totalAmount کی رقم ادا کی ہے۔";
                                           msgData += '\n';
                                           msgData += 'آگر یہ رقم درست ہے تو کنفرمیش کے لئے کوڈ $msgPin ہمارے نمائندے کو دے دیجئے۔';
                                           msgData += '\n';
                                           msgData += 'آگر یہ رقم درست نہیں تو ہمارے نمائندے کو کوڈ نہیں دیجئے۔';
                                           msgData += '\n';
                                           msgData += 'شکریہ۔';

                                           var response = await OnlineDataBase.sendTextMultiple(tempContact, msgData);
                                           if(response.statusCode == 200){
                                             setLoading(false);
                                             Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                     builder: (_) => PaymentPin(
                                                       pin: msgPin,
                                                       contactNumbers: tempContact,
                                                       onSuccess: (){
                                                         print("@@@@@@@@@@@@@");
                                                         //setLoading(false);
                                                         postPayment();
                                                       },
                                                     )
                                                 ));
                                           }else{
                                             setLoading(false);
                                             Fluttertoast.showToast(
                                                 msg: "Code not sent, Try again",
                                                 toastLength: Toast.LENGTH_SHORT);
                                           }
                                        }
                                        },
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => PaymentUsingCheck(
                                              paymentTypedetails:
                                                  paymentType['payment']
                                                      [index],customerData: widget.customerData,lat: widget.lat,long: widget.long,)));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: height * 0.025,
                                  width: height * 0.025,
                                  decoration: BoxDecoration(
                                      //color:Colors.red,
                                      //color: selectedIndex[index]==true ? themeColor1 : Colors.white,
                                      border: Border.all(
                                          color: paymenttypeSelected == index
                                              ? Color(0xff323232)
                                              : Color(0xff7A7A7A),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                      child: paymenttypeSelected == index
                                          ? Icon(Icons.circle,
                                              size: 11,
                                              color: Color(0xff323232))
                                          : Container()),
                                ),
                                SizedBox(
                                  width: height * 0.02,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Image.asset(
                                    paymentType['payment'][index]['image'],
                                    scale: 3.5,
                                  ),
                                ),
                                SizedBox(
                                  width: height * 0.01,
                                ),
                                VariableText(
                                  //textAlign: TextAlign.center,
                                  text: paymentType['payment'][index]['name'],
                                  fontsize: 13,
                                  fontcolor: paymenttypeSelected == index
                                      ? themeColor1
                                      : textcolorblack,
                                  weight: FontWeight.w500,
                                ),
                                Spacer(),
                                showAmount
                                    ? Container(
                                        child: paymenttypeSelected == index
                                            ? VariableText(
                                                text: 'Rs.$totalAmount',
                                                fontsize: 13,
                                                fontcolor: textcolorblack,
                                                weight: FontWeight.w700,
                                              )
                                            : Container(),
                                      )
                                    : Container(
                                        child: paymenttypeSelected == index
                                            ? Icon(
                                                Icons.check,
                                                color: themeColor1,
                                                size: 20,
                                              )
                                            : Container(),
                                      ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: height * sizedboxvalue,
                  ),
                ],
              );
            }),
        //SizedBox(height:height*sizedboxvalue,),
      ],
    );
  }

  bool validateFields() {
    bool ok = false;
    if (Name.isNotEmpty) {
      if (totalAmount.isNotEmpty) {
        ok=true;
      } else {
        Fluttertoast.showToast(
            msg: "Please Enter Amount", toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Name", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }
  postPayment() async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.postPayment(customerCode: widget.customerData.customerCode,lat: widget.lat.toString(),long: widget.long.toString(),amount: totalAmount,name: Name,paymentMode: '1');
      print("status code is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        var respnseData=jsonDecode(utf8.decode(response.bodyBytes));
        print("response is"+respnseData['results'].toString());

        List<String> tempContact = [];
        if(widget.customerData.customerContactNumber != null){
          tempContact.add(widget.customerData.customerContactNumber.substring(0, widget.customerData.customerContactNumber.length));
        }
        if(widget.customerData.customerContactNumber2 != null){
          tempContact.add(widget.customerData.customerContactNumber2);
        }else{
          //tempContact.add('+923340243440');
        }
        String msgData = "آپ نے $totalAmount روپے ادا کر دئے ہیں۔ شکریہ۔";

        var responseMsg = await OnlineDataBase.sendTextMultiple(tempContact, msgData);
        if(responseMsg.statusCode == 200){
          print("Message sent!!!!!");
        }

        setLoading(false);
        Fluttertoast.showToast(
            msg: "Payment Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(context,MaterialPageRoute(builder: (_)=>SucessFullyRecivePaymentScreen(shopDetails: widget.customerData,long: widget.long,lat: widget.lat,)));
      } else {
        setLoading(false);
        Fluttertoast.showToast(
          msg: "Something went wrong try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e,stack) {
      setLoading(false);
      Fluttertoast.showToast(
        msg: "Something went wrong try again later",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("exception in post payment method is" + e.toString()+stack.toString());
    }
  }
  bool setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void showDialog(double height, double width, var paymentTypedetails,
      Function onselected) {
    double sizedboxvalue = 0.02;

    TextEditingController amount = new TextEditingController();
    TextEditingController name = new TextEditingController();
    checkBody(double height, double width) {
      return Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              VariableText(
                text: 'Enter Cheque Number',
                fontsize: 12,
                fontcolor: textcolorblack,
                weight: FontWeight.w500,
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: themeColor2,
                //  border: Border.all(color: Color(0xffEEEEEE))
              ),
              height: height * 0.06,
              child: TextFormField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(14),
                ],

                style: TextStyle(fontSize: 14, color: textcolorgrey),
                //onChanged: enableBtn ,
                //controller: _numController,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  //isCollapsed: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: feildunderlineColor),
                  ),

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: '**** **** **** 1234',

                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: textcolorlightgrey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              VariableText(
                text: 'Enter Beneficiary Name',
                fontsize: 12,
                fontcolor: textcolorblack,
                weight: FontWeight.w500,
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: themeColor2,
                //  border: Border.all(color: Color(0xffEEEEEE))
              ),
              height: height * 0.06,
              child: TextFormField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(14),
                ],

                style: TextStyle(fontSize: 14, color: textcolorgrey),
                //onChanged: enableBtn ,
                //controller: _numController,
                keyboardType: TextInputType.text,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8),
                  //isCollapsed: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: feildunderlineColor),
                  ),

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: 'Ayaz Qureshi',

                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: textcolorlightgrey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              VariableText(
                text: 'Enter the amount',
                fontsize: 12,
                fontcolor: textcolorblack,
                weight: FontWeight.w500,
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: themeColor2,
                //  border: Border.all(color: Color(0xffEEEEEE))
              ),
              height: height * 0.06,
              child: TextFormField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,

                style: TextStyle(fontSize: 14, color: textcolorgrey),
                //onChanged: enableBtn ,
                controller: amount,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: feildunderlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: '4,045.00',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: textcolorlightgrey,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    child: Text(
                      'Rs.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                         ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      );
    }

    cashBody(double height, double width) {
      return Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              VariableText(
                text: 'Enter Beneficiary Name',
                fontsize: 12,
                fontcolor: textcolorblack,
                weight: FontWeight.w500,

              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: themeColor2,
                //  border: Border.all(color: Color(0xffEEEEEE))
              ),
              height: height * 0.06,
              child: TextFormField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(14),
                ],
                style: TextStyle(fontSize: 14, color: textcolorgrey),
                //onChanged: enableBtn ,
                controller: name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8),
                  //isCollapsed: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: feildunderlineColor),
                  ),

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: 'Ayaz Qureshi',

                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: textcolorlightgrey,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            children: [
              VariableText(
                text: 'Enter the amount',
                fontsize: 12,
                fontcolor: textcolorblack,
                weight: FontWeight.w500,
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Material(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: themeColor2,
                //  border: Border.all(color: Color(0xffEEEEEE))
              ),
              height: height * 0.06,
              child: TextFormField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,

                style: TextStyle(fontSize: 14, color: textcolorgrey),
                //onChanged: enableBtn ,
                controller: amount,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: feildunderlineColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  hintText: '4,045.00',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: textcolorlightgrey,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    child: Text(
                      'Rs.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                         ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      );
    }
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        //  height:paymentTypedetails['name']=='Cheque'? height*0.48:height*0.38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            // crossAxisAlignment: CrossA,
            children: [
              Row(
                children: [
                  Image.asset('assets/icons/paymentwallet.png',
                      color: themeColor1, scale: 3.3),
                  SizedBox(
                    width: height * 0.01,
                  ),
                  VariableText(
                    text: paymentTypedetails['name'] == 'Cheque'
                        ? 'Payment Using Cheque'
                        : 'Payment Using Cash on delivery',
                    fontsize: 13,
                    fontcolor: textcolorblack,
                    weight: FontWeight.w700,

                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/icons/cross.png', scale: 3.5)),
                ],
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Container(
                height: height * 0.07,
                width: width,
                /*    decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/icons/circle.png')
                    )
                ),*/
                child: Center(
                    child:
                        Image.asset(paymentTypedetails['image1'], scale: 2.5)),
              ),
              paymentTypedetails['name'] == 'Cheque'
                  ? checkBody(height, width)
                  : cashBody(height, width),
              SizedBox(
                height: height * 0.01 / 2,
              ),
              GestureDetector(
                onTap: () {

                  onselected(amount.text.toString(), name.text);

                },
                child: Container(
                  height: height * 0.06,
                  decoration: BoxDecoration(
                    color: themeColor1,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                      child: VariableText(
                        text: 'SUBMIT',
                        weight: FontWeight.w700,
                        fontsize: 15,
                        fontcolor: themeColor2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    )..show();

/*    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return ShowDeliveryDetailsDialouge(height: height,width: width,paymentTypedetails: paymentTypedetails, onselected: (temp){
          Navigator.of(context).pop();
          setState(() {
            totalAmount=temp;
          });

        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );*/
  }
}
