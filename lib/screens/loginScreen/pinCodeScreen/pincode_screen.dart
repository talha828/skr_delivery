
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:skr_delivery/screens/loginScreen/loginSuccessful/login_successful.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';

import '../../widget/constant.dart';

class PinCodeScreen extends StatefulWidget {
  PinCodeScreen({this.phoneNo,this.verificationId,this.password});
  final phoneNo;
  final verificationId;
  final password;
  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  bool loading =false;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/logo.png",
                      scale: 3,
                    ),
                  )),
                    Text(
                 "Enter a 6 digit code send you at +923012070920",
                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                 ),
              SizedBox(
                height: 10,
              ),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                length: 6,
                obscureText: false,
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                  inactiveColor: Colors.grey,
                  disabledColor: Colors.black,
                  inactiveFillColor: Colors.white,
                  shape: PinCodeFieldShape.underline,
                  errorBorderColor: Colors.grey,
                  selectedColor: themeColor1,
                  selectedFillColor:  Colors.white,
                  activeColor: themeColor1,
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor:  Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor:  Colors.white,
                enableActiveFill: true,
                controller: controller,
                onCompleted: (value) {
                  var _credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: controller.text.toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginSuccessful(password: widget.password.toString(),)));
                  print("Completed");

                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                }, appContext: context,
              ),
              SizedBox(height: 10,),
              Text("Resend Code in 00:59",style: TextStyle(color: Colors.grey),)
            ],
          ),
        ),
      ),
    );
  }
}
