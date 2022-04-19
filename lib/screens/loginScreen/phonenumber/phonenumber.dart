import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/password_screen.dart';
import '../../widget/constant.dart';

class PhoneNumber extends StatefulWidget {

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController controller = TextEditingController();

  checkPhoneNumber(controller){
    if(controller.text!=null){
      if(controller.text.length==10){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordScreen(phoneNumber: "+92"+controller.text,)));
      }
      else{
        Alert(
          context: context,
          type: AlertType.error,
          title: "Invalid Phone Number",
          desc: "Please check your Phone Number",
          buttons: [
            DialogButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }else{
      Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid Phone Number",
        desc: "Please check your phone Number",
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: FloatingActionButton(
                onPressed: ()=>checkPhoneNumber(controller),
                child: Icon(Icons.arrow_forward_rounded),
                backgroundColor:themeColor1
            ),
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
                    "What`s your phone number?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "We’ll text  a code to verify your phone.",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: 15, color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "3012345658",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
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
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
    );
  }
}
