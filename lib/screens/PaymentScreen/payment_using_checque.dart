import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skr_delivery/screens/PaymentScreen/sucessfully_recived_payment_screen.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import '../../ApiCode/online_database.dart';

///image picker use here
//import 'package:image_picker/image_picker.dart';

class PaymentUsingCheck extends StatefulWidget {
  var paymentTypedetails;
  final customerData;
  var lat,long;
  PaymentUsingCheck({this.paymentTypedetails,this.customerData,this.lat,this.long});
  File _image1;

  @override
  _PaymentUsingCheckState createState() => _PaymentUsingCheckState();
}

class _PaymentUsingCheckState extends State<PaymentUsingCheck> {


  double sizedboxvalue=0.02;

  TextEditingController amount=new TextEditingController();
  TextEditingController date=new TextEditingController();
  TextEditingController name=new TextEditingController();
  TextEditingController checkNumber=new TextEditingController();
  String totalAmount='0';
  File image;
  bool showImage=false;
  bool isLoading=false;
  String startDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        helpText: "Select Date",
        builder: (BuildContext context, Widget child) {
          return  Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor1, // header background color
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
    if (picked != null)
      setState(() {
        startDate=picked.toString().split(" ")[0];
        date.text = startDate;
      });

  }

  _imgFromGallery() async {
    var image = await  ImagePicker.pickImage(source:ImageSource.gallery, imageQuality: 50);
    if(image != null){
      setState(() {
       this.image = image ;
        showImage=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar:  AppBar(
            iconTheme: IconThemeData(color: textcolorblack),
            elevation: 0.5,

            backgroundColor: themeColor2,
            title:
            VariableText(
              text: 'Payment Using Cheque',
              fontsize:16,fontcolor: textcolorblack,
              weight: FontWeight.w600,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:height*sizedboxvalue*3,),
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                            child: Column(
                              children: [
                                SizedBox(height: height*0.09,),
                                Row(
                                  children: [
                                    VariableText(
                                      text:'Enter Cheque Number',
                                      fontsize:12,fontcolor: textcolorblack,
                                      weight: FontWeight.w500,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: height*0.005,),
                                Material(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeColor2,
                                      //  border: Border.all(color: Color(0xffEEEEEE))
                                    ),
                                    height: height * 0.06,
                                    child:
                                    TextFormField
                                      (
                                    /*  textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                    */  inputFormatters: [
                                        LengthLimitingTextInputFormatter(14),],


                                      style: TextStyle(
                                          fontSize: 14,
                                          color:  Color(0xff333333)

                                      ),
                                      //onChanged: enableBtn ,
                                      controller: checkNumber,
                                      keyboardType: TextInputType.number,

                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 8),
                                        //isCollapsed: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: feildunderlineColor),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red)),
                                        hintText: '**** **** **** 1234',


                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),


                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height*0.01,),
                                Row(
                                  children: [
                                    VariableText(
                                      text:'Enter Beneficiary Name',
                                      fontsize:12,fontcolor: textcolorblack,
                                      weight: FontWeight.w500,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: height*0.005,),
                                Material(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeColor2,
                                      //  border: Border.all(color: Color(0xffEEEEEE))
                                    ),
                                    height: height * 0.06,
                                    child:
                                    TextFormField
                                      (
                                      textAlign: TextAlign.start,
                                      textAlignVertical: TextAlignVertical.center,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(14),],


                                      style: TextStyle(
                                          fontSize: 14,
                                        color: Color(0xff333333),

                                      ),
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
                                          color: Colors.grey,
                                        ),


                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height*0.01,),
                                Row(
                                  children: [
                                    VariableText(
                                      text:'Enter amount',
                                      fontsize:12,fontcolor: textcolorblack,
                                      weight: FontWeight.w500,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: height*0.005,),
                                Material(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: themeColor2,
                                      //  border: Border.all(color: Color(0xffEEEEEE))
                                    ),
                                    height: height * 0.06,
                                    child:
                                    TextFormField(
                                      textAlign: TextAlign.left,
                                      //textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:  Color(0xff333333)
                                      ),
                                      //onChanged: enableBtn ,
                                      controller: amount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                       // isCollapsed: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: feildunderlineColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: themeColor1)),
                                        hintText: '1000.00',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(left: 10, top: 16, right: 0),
                                          child: Text(
                                            'Rs.',
                                            style: TextStyle(
                                                fontSize: 14, fontWeight: FontWeight.w500,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height*0.01,),
                                Row(
                                  children: [
                                    VariableText(
                                      text:'Select Date',
                                      fontsize:12,fontcolor: textcolorblack,
                                      weight: FontWeight.w500,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: height*0.005,),
                                Material(
                                  child: InkWell(
                                    onTap: (){
                                      _selectDate(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: themeColor2,
                                      ),
                                      height: height * 0.06,
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:  Color(0xff333333)
                                        ),
                                        //onChanged: enableBtn ,
                                        controller: date,
                                        enabled: false,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                          // isCollapsed: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: feildunderlineColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: feildunderlineColor)),
                                          disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: feildunderlineColor)),
                                            hintText: 'Open calendar',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height*0.01/2,),
                                SizedBox(height: height*0.01,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: -20,
                           child: Align(
                          alignment: Alignment.topCenter,

                          child:  FloatingActionButton(
                              mini: false,
                              elevation: 0,
                              backgroundColor: Color(0xffF6821F),
                              child: Image.asset(widget.paymentTypedetails['image1'], scale: 2.5),
                              onPressed: () {
                              }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:height*sizedboxvalue*1.5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Column(
                          children: [
                            SizedBox(height: height*0.01,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text:'Upload an Image ',
                                  fontsize:15,fontcolor: Color(0xff151515),
                                  weight: FontWeight.w700,
                                ),
                              ],
                            ),
                            SizedBox(height: height*0.02,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text:'File should be Png and Jpeg.',
                                  fontsize:12,fontcolor: Color(0xff555555),
                                  weight: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizedBox(height: height*0.02,),
                            showImage!=true ?
                            Stack(
                              children: [
                                Container(
                                  height: height*0.16,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xffFFEEE0),
                                  ),
                                  child: DashedRect(color:themeColor1, strokeWidth: 1.5, gap: 8.0,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                     height: height*0.14,
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Color(0xffFFEEE0),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: GestureDetector(
                                        onTap: (){
                                          _imgFromGallery();
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                          //  Spacer(),
                                            Image.asset("assets/icons/folder.png",scale: 3.5,),
                                            SizedBox(height: height*0.02,),
                                            VariableText(text: "Select Cheque image from gallery",
                                              fontsize: 13,
                                              weight: FontWeight.w400,
                                              fontcolor: textcolorblack,
                                              ),
                                          ],
                                        )),
                                  ),
                                ),

                              ],
                            ):
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: height*0.16,
                                    width: width,
                                    color: Colors.white,
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          showImage=false;
                                          image = null;
                                        });
                                      },
                                      child:
                                      Stack(
                                        children: [
                                          ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                colors: <Color>[Colors.grey, Colors.grey],
                                              ).createShader(bounds);
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5.0),
                                              child: Image.file(
                                                image,
                                                height: height*0.16,
                                                width: width,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),

                                          Align(
                                            child: Image.asset('assets/icons/circleminus.png',scale: 3,),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height*0.0055,),

                           // SizedBox(height: height*0.02,),
                          ],
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height:height*sizedboxvalue,),
                   ]
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              child: Container(
                height: height*0.13,
                color: themeColor2,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15),
                  child: Column(

                    children: [
                      SizedBox(height: height*sizedboxvalue,),
                      Row(
                        children: [
                          VariableText(
                            text:'Total',
                            fontsize:13,fontcolor: textcolorblack,
                            weight: FontWeight.w700,
                          ),
                          VariableText(
                            text:' (including all Tax)',
                            fontsize:13,fontcolor: textcolorgrey,
                            weight: FontWeight.w400,
                          ),
                          Spacer(),
                          VariableText(
                            text:'Rs.${amount.text}',
                            fontsize:13,fontcolor: textcolorblack,
                            weight: FontWeight.w700,
                          ),

                        ],
                      ),
                      SizedBox(height: height*sizedboxvalue/2,),
                      InkWell(
                        onTap: (){
                          if (validateFields()) {
                            //Navigator.of(context).pop();
                            startPost();
                          }
                       },

                        child: Container(
                          height: height*0.06,
                          decoration: BoxDecoration(
                            color:/*  showImage!=true ?Color(0xffBDBDBD):*/themeColor1,
                            borderRadius: BorderRadius.circular(4),

                          ),

                          child:   Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 15),
                            child: Center(
                              child: VariableText(
                                text:'SUBMIT',
                                weight: FontWeight.w700,
                                fontsize: 15,
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
          )),isLoading?Positioned.fill(child: loader()):Container()
      ],
    );
  }

  bool validateFields() {
    bool ok = false;
    if (checkNumber.text.isNotEmpty) {
      if (name.text.isNotEmpty) {
        if (amount.text.isNotEmpty) {
          if(startDate != null){
            ok=true;
          }else{
            Fluttertoast.showToast(
                msg: "Please select date", toastLength: Toast.LENGTH_SHORT);
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please Enter Amount", toastLength: Toast.LENGTH_SHORT);
        }

      } else {
        Fluttertoast.showToast(
            msg: "Please Enter Name", toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Check Number", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }

  Future<void> startPost() async {
    setLoading(true);
    if(image != null){
      var tempImage = await MultipartFile.fromFile(image.path,
          filename: "${DateTime.now().millisecondsSinceEpoch.toString()}.${image.path.split('.').last}",
          contentType: new MediaType('image', 'jpg'));
      print(tempImage.filename);
      postImage(tempImage);
    }else{
      postPayment('');
    }
  }

  postPayment(String imageUrl) async {
    try {
      setLoading(true);
      var response = await OnlineDataBase.postPayment(customerCode: widget.customerData.customerCode, imageUrl: imageUrl,lat: widget.lat.toString(),long: widget.long.toString(),amount: amount.text,name: name.text,checkNumber: checkNumber.text,paymentMode: '2', date: startDate);
      print("status code is: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        var respnseData=jsonDecode(utf8.decode(response.bodyBytes));
        print("response is: "+respnseData['results'].toString());
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

  void postImage(var image) async {
    try {
      var response = await OnlineDataBase.uploadImage(
          type: 'cheqdeposit',
          image: image
      );
      if(response){
        setLoading(false);
        print("Success");
        String imageUrl = 'https://suqexpress.com/assets/images/cheqdeposit/${image.filename}';
        postPayment(imageUrl);
      }else{
        setLoading(false);
        print("failed");
        Fluttertoast.showToast(msg: 'Image upload failed', toastLength: Toast.LENGTH_SHORT);
      }

    } catch (e, stack) {
      setLoading(false);
      print('exception is: ' + e.toString());
      setLoading(false);
    }
  }

  bool setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
