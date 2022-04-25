import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skr_delivery/screens/ForgetPasswordScreen/verifcation_code_screen.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';

class ForgetPasswordVerifyPhoneNoScreen extends StatefulWidget {
  @override
  _ForgetPasswordVerifyPhoneNoScreenState createState() =>
      _ForgetPasswordVerifyPhoneNoScreenState();
}

class _ForgetPasswordVerifyPhoneNoScreenState
    extends State<ForgetPasswordVerifyPhoneNoScreen> {
  bool isLoading = false;
  TextEditingController _numController = new TextEditingController();
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
                    text: "What’s your number?",
                    fontsize: 22,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  VariableText(
                    text: "We’ll text  a code to verify your phone.",
                    fontsize: 13,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    //color: Colors.red,
                    // height: height*0.035,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      //onChanged: enableBtn ,
                      controller: _numController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Number';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: themeColor1),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 00,
                          horizontal: 0.0,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hintText: '305 5520912',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: textcolorlightgrey,
                        ),
                        prefixIcon: Padding(
                          padding:
                              EdgeInsets.only(right: 0, top: height * 0.019),
                          child: Text(
                            '  +92',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 1.0,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                backgroundColor: themeColor1,
                onPressed: () {
                  nextScreen();
                })),
        isLoading ? Positioned.fill(child: loader()) : Container(),
      ],
    );
  }

  void nextScreen() async {
    if (validateFields()) {
      setLoading(true);
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.verifyPhoneNumber(
          phoneNumber: '+92' + _numController.text,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential credential) {},
          verificationFailed: (FirebaseAuthException exception) {
            print("OTP failed");
            setLoading(false);
            Fluttertoast.showToast(
                msg: "OTP failed, Try again later",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: 16.0);
            print(exception);
          },
          codeAutoRetrievalTimeout: null,
          codeSent: (String verificationId, [int forceResendingToken]) {
            Navigator.push(
                context,
                NoAnimationRoute(
                    widget: ForgetPasswordVerificationCodeScreen(
                  verificationCode: verificationId,
                  phoneNumber: "+92" + _numController.text,
                )));
            setLoading(false);
          });
    }
  }

  bool validateFields() {
    bool ok = false;
    if (_numController.text.isNotEmpty) {
/*      if('+92'+_numController.text.toString()==phoneno.toString()){*/
      ok = true;
/*    }
      else{
        Fluttertoast.showToast(msg: "Phone Number is not Exist", toastLength: Toast.LENGTH_SHORT);
      }*/

    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Phone Number", toastLength: Toast.LENGTH_SHORT);
    }
    return ok;
  }

  setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }
}
