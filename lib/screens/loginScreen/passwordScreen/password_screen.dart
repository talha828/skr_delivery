import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/ApiCode/online_auth.dart';
import 'package:skr_delivery/screens/ForgetPasswordScreen/verify_phone_no_screen.dart';
import 'package:skr_delivery/screens/loginScreen/loginSuccessful/login_successful.dart';
import 'package:skr_delivery/screens/loginScreen/pinCodeScreen/pincode_screen.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import '../../widget/constant.dart';
import 'loader.dart';

class PasswordScreen extends StatefulWidget {
  PasswordScreen({this.phoneNumber});
  final phoneNumber;
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool selected = true;
  bool value = true;
  bool loading = false;
  TextEditingController controller = TextEditingController();

  verifyPhoneNo(var data) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber.toString(),
        verificationCompleted: (credential) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginSuccessful(
                        password: controller.text.toString(),
                      )));
        },
        verificationFailed: (authException) {
          Alert(
            context: context,
            type: AlertType.error,
            title: "Authentication Failed",
            desc: "Please check your number ",
            buttons: [
              DialogButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  setState(() {
                    loading = false;
                  });
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
          print(authException.message);
          print('auth fail error');
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          //show dialog to take input from the user
          // Provider.of<UserModel>(context,listen: false).userSignIn(data);
          // showDialog(
          //     context: context,
          //     barrierDismissible: false,
          //     builder: (context) => PinCodeScreen(phoneNo: widget.phoneNumber,verificationId: verificationId,)
          // );
          Provider.of<UserModel>(context, listen: false).userSignIn(data);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PinCodeScreen(
                        password: controller.text,
                        phoneNo: widget.phoneNumber,
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
  }

  // login user account
  getLogin(controller) async {
    setState(() {
      loading = true;
    });
    if (controller.text != null) {
      var response = await Auth.signIn2(widget.phoneNumber, controller.text).catchError((e)=>print("error: $e"));
      if (response.statusCode == 200) {
        //TODO got model extract data
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        verifyPhoneNo(data);
      } else if (response.statusCode == 401) {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Authentication Failed",
          desc: "Please check your number and password",
          buttons: [
            DialogButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                setState(() {
                  loading = false;
                });
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: "Somethings went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Password field is Empty",
        desc: "Please provider a password",
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              setState(() {
                loading = false;
              });
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                getLogin(controller);
              },
              child: Icon(Icons.arrow_forward_rounded),
              backgroundColor: themeColor1),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset("assets/logo.png", scale: 3,),
                    )),
                Text(
                  "Login Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Enter your password for login",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: selected,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            selected = selected ? false : true;
                          });
                        },
                        child: selected
                            ? Image.asset(
                                "assets/eye.png",
                                scale: 3,
                              )
                            : Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              )),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 00,
                      horizontal: 0.0,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: themeColor1)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE3E3E3)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                              activeColor: themeColor1,
                              value: this.value,
                              onChanged: (value) {
                                setState(() {
                                  this.value = value;
                                });
                              }),
                          Text(
                            "keep me logged in",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForgetPasswordVerifyPhoneNoScreen())),
                      child: Text(
                        "forget password?",
                        style: TextStyle(color: themeColor1),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        loading ? loader() : Container()
      ],
    ));
  }
}
