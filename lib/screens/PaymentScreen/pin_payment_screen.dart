import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';

import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/child_lock/security_screen.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';

class PaymentPin extends StatefulWidget {
  String pin;
  List<String> contactNumbers;
  Function onSuccess;
  Function onFailed;
  CustomerModel customer;
  String userName;
  String total;

  PaymentPin({Key key, this.pin, this.contactNumbers, this.onSuccess, this.onFailed,this.customer,this.total,this.userName}) : super(key: key);

  @override
  _PaymentPinState createState() => _PaymentPinState();
}

class _PaymentPinState extends State<PaymentPin> {
  TextEditingController txt1,txt2,txt3,txt4;
  String enteredPin;
  Timer _timer;
  int _start = 60;
  String number1,number2,number3;
  String name1,name2,name3;
  String code;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  bool isLoading=false;
  bool setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
  CustomerModel userDetails;
  getUser() async {
    setLoading(true);
    var response =
    await OnlineDataBase.getSingleCustomer(widget.customer.customerCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data.toString());
      userDetails = CustomerModel.fromModel(data['results'][0]);
      name1=userDetails.customerName;
      name2=userDetails.customerContactPersonName2;
      name3="NULL";
      number1=userDetails.customerContactNumber;
      number2=userDetails.customerContactNumber2;
      number3="NULL";
      setState(() {});
    } else {
      print("User not found!!!!!");
    }
    setLoading(false);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    name1=widget.customer.customerName;
    name2=widget.customer.customerContactPersonName2;
    name3="NULL";
    number1=widget.customer.customerContactNumber;
    number2=widget.customer.customerContactNumber2;
    number3="NULL";
    code=widget.pin;
    startTimer();
    super.initState();
    txt1=TextEditingController();
    txt2=TextEditingController();
    txt3=TextEditingController();
    txt4=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;

    return SafeArea(
        child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VariableText(text: name1,
                                fontsize: height * 0.020,
                                textAlign: TextAlign.start,
                                line_spacing: 1,
                                fontcolor: textcolorblack,
                                ),
                              SizedBox(height: height*0.01),
                              VariableText(text: widget.customer.customerCode,
                                fontsize: height * 0.020,
                                textAlign: TextAlign.start,
                                line_spacing: 1,
                                fontcolor: textcolorblack,
                                ),
                              SizedBox(height: height*0.01),
                            ],),
                          Container(child: VariableText(text: number1,
                            fontsize: height * 0.020,
                            textAlign: TextAlign.start,
                            line_spacing: 1,
                            fontcolor: textcolorblack,
                            ),)
                        ],),
                      Spacer(),
                      VariableText(text: "Enter the 4-digit code sent to",
                        fontsize: height * 0.025,
                        textAlign: TextAlign.start,
                        line_spacing: 1,
                        fontcolor: textcolorblack,
                        ),
                      SizedBox(height: height*0.01),
                      // Column(
                      //   children: List.generate(widget.contactNumbers.length, (index){
                      //     return VariableText(text: widget.contactNumbers[index],
                      //       fontsize: height * 0.020,
                      //       textAlign: TextAlign.start,
                      //       line_spacing: 1,
                      //       fontcolor: textcolorblack,
                      //       fontFamily: fontRegular);
                      //   }),
                      // ),
                      SizedBox(height: height*0.02),
                      Row(
                        children: [
                          createCodeField(txt1,txt2),SizedBox(width: 15),
                          createCodeField(txt2,txt3),SizedBox(width: 15),
                          createCodeField(txt3,txt4),SizedBox(width: 15),
                          createCodeField(txt4,null),
                        ],
                      ),
                      SizedBox(height: height*0.05),
                      LoginButton(text: "Verify",onTap: (){
                        print(enteredPin);
                        print(code);
                        if(enteredPin.toString() == code.toString()){
                          Navigator.of(context).pop();
                          widget.onSuccess();
                        }else{
                          Fluttertoast.showToast(
                              msg: "Incorrect pin",
                              toastLength: Toast.LENGTH_SHORT);
                        }
                      },),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: ()async{
                              if(_start==0){
                                setLoading(true);
                                String msgPin = '';
                                var rng = Random();
                                for (var i = 0; i < 4; i++) {
                                  msgPin += rng.nextInt(9).toString();
                                }
                                print(msgPin);
                                String msgData='Use $msgPin  to confirm Rs  ${widget.total} to ${widget.userName} %26 Download app https://bit.ly/38uffP8';
                                msgData+= ' ID: ${number1} Pass: 555 or Call 03330133520';
                                var response = await OnlineDataBase.sendText(number1, msgData);
                                if(response.statusCode == 200){
                                  _start=60;
                                  setState(() {
                                    code=msgPin.toString();
                                  });
                                  startTimer();
                                }
                                else{
                                  Fluttertoast.showToast(
                                      msg: "Code not sent, Try again",
                                      toastLength: Toast.LENGTH_SHORT);
                                }
                              }
                              setLoading(false);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: _start==0?themeColor1:Colors.white,
                              ),
                              child: VariableText(text: "Resend: ${_start}",
                                  fontsize: height * 0.025,
                                  textAlign: TextAlign.start,
                                  line_spacing: 1,
                                  fontcolor: _start==0?Colors.white:textcolorblack,
                                  ),
                            ),
                          ),
                          IconButton(onPressed: ()=>getUser(), icon:Icon(Icons.refresh,color: themeColor1,))
                        ],),
                      Spacer(),
                      InkWell(
                        onTap: ()async{
                          if(_start==0 && number2!="NULL" && double.parse(number2) > 1){
                            setLoading(true);
                            String msgPin = '';
                            var rng = Random();
                            for (var i = 0; i < 4; i++) {
                              msgPin += rng.nextInt(9).toString();
                            }
                            print(msgPin);
                            String msgData='Use $msgPin  to confirm Rs  ${widget.total} to ${widget.userName} %26 Download app https://bit.ly/38uffP8';
                            msgData+= ' ID: ${number2} Pass: 555 or Call 03330133520';
                            var response = await OnlineDataBase.sendText(number2, msgData);
                            if(response.statusCode == 200){
                              _start=60;
                              setState(() {
                                code=msgPin.toString();
                              });
                              startTimer();
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Code not sent, Try again",
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Error: " +e.toString(),
                                toastLength: Toast.LENGTH_SHORT);
                          }
                          setLoading(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _start==0?themeColor1:Colors.grey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        VariableText(
                                          text: name2.toString()== "NULL"?"Number not Found":name2.toString(),
                                          textAlign: TextAlign.center,
                                          fontsize: 15,
                                          fontcolor: themeColor2,
                                        ),
                                        VariableText(
                                          text: number2.toString()== "NULL" || number2.toString()== 1.toString()?"":number2.toString(),
                                          textAlign: TextAlign.center,
                                          fontsize: 15,
                                          fontcolor: themeColor2,
                                        ),
                                      ],),
                                    Spacer(),
                                    Icon(Icons.arrow_forward,color: Colors.white,)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: ()async{
                          if(_start==0 && number3!="NULL" && number3 != 1.toString){
                            setLoading(true);
                            String msgPin = '';
                            var rng = Random();
                            for (var i = 0; i < 4; i++) {
                              msgPin += rng.nextInt(9).toString();
                            }
                            print(msgPin);
                            String msgData='Use $msgPin  to confirm Rs  ${widget.total} to ${widget.userName} %26 Download app https://bit.ly/38uffP8';
                            msgData+= ' ID: ${number3} Pass: 555 or Call 03330133520';
                            var response = await OnlineDataBase.sendText(number3, msgData);
                            if(response.statusCode == 200){
                              _start=60;
                              setState(() {
                                code=msgPin.toString();
                              });
                              startTimer();
                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Code not sent, Try again",
                                  toastLength: Toast.LENGTH_SHORT);
                            }
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Something went wrong",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                          setLoading(false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _start==0?themeColor1:Colors.grey,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        VariableText(
                                          text: name3.toString()== "NULL"?"Number not Found":name3.toString(),
                                          textAlign: TextAlign.center,
                                          fontsize: 15,
                                          fontcolor: themeColor2,
                                        ),
                                        VariableText(
                                          text: number3.toString()== "NULL" ||number3.toString()== 1.toString()?"":number3.toString(),
                                          textAlign: TextAlign.center,
                                          fontsize: 15,
                                          fontcolor: themeColor2,
                                        ),
                                      ],),
                                    Spacer(),
                                    Icon(Icons.arrow_forward,color: Colors.white,)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],),
                ),
                isLoading ? Positioned.fill(child: loader()) : Container(),
              ],
            )));
  }

  Widget createCodeField(TextEditingController cont,TextEditingController next_cont){
    return Expanded(
        child:CodeField(
          cont: cont,
          next_cont: next_cont,
          onComplete: (value){
            setState(() {
              enteredPin = txt1.text+txt2.text+txt3.text+txt4.text;
            });
            print(enteredPin);
          },
        ));
  }

}
