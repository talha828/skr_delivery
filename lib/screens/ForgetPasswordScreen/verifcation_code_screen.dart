import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/screens/ForgetPasswordScreen/change_password_screen.dart';
import 'package:skr_delivery/screens/ForgetPasswordScreen/verify_phone_no_screen.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';

class ForgetPasswordVerificationCodeScreen extends StatefulWidget {
  var verificationCode;
  var phoneNumber;
  ForgetPasswordVerificationCodeScreen(
      {this.verificationCode, this.phoneNumber});

  @override
  _ForgetPasswordVerificationCodeScreenState createState() =>
      _ForgetPasswordVerificationCodeScreenState();
}

class _ForgetPasswordVerificationCodeScreenState
    extends State<ForgetPasswordVerificationCodeScreen> {
  bool hasError = false;
  String currentText = "";
  String otpCode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.07,
                ),
                Center(
                    child: Image.asset(
                  "assets/icons/splashlogo.png",
                  scale: 3.5,
                )),
                SizedBox(
                  height: height * 0.05,
                ),
                VariableText(
                  text: "Enter the 6-digit code sent to you at",
                  fontsize: 16,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                VariableText(
                  text: widget.phoneNumber,
                  fontsize: 16,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                OTPTextField(
                  length: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 35,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  keyboardType: TextInputType.number,
                  textFieldAlignment: MainAxisAlignment.start,
                  otpFieldStyle: OtpFieldStyle(
                    enabledBorderColor: Color(0xff7A7A7A),
                    focusBorderColor: Color(0xff7A7A7A),
                  ),
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    setState(() {
                      otpCode = pin.toString();
                    });
                    /*   Navigator.push(
                              context, NoAnimationRoute(widget: SucessFullyVerifiedScreen()));
*/
                    verifyOtp();
                    print("Completed: " + pin);
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                VariableText(
                  text: "Resend code in 00:59",
                  fontsize: 13,
                ),
              ],
            ),
          ),
          /*       floatingActionButton: new FloatingActionButton(
                elevation: 1.0,
                child:   Image.asset('assets/icons/arrow_forward.png',scale: 1.8,),
                backgroundColor: themeColor1,
                onPressed: (){
                  Navigator.push(
                  context, NoAnimationRoute(widget: ChangePasswordScreen(phoneNo: widget.phoneNumber,)));}
                  )*/
        ),
        isLoading ? Positioned.fill(child: loader()) : Container(),
      ],
    );
  }

  void verifyOtp() async {
    setLoading(true);
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationCode.toString(), smsCode: otpCode);
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      if (user != null) {
        setLoading(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('phoneno');
        prefs.remove('password');
        Navigator.push(
            context,
            NoAnimationRoute(
                widget: ChangePasswordScreen(
              phoneNo: widget.phoneNumber,
            )));
      } else {
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Invalid OTP , Try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(context,
            NoAnimationRoute(widget: ForgetPasswordVerifyPhoneNoScreen()));
      }
    } catch (e) {
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Invalid OTP , Try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
      print("exceptxc;ion is" + e.toString());
    }
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
