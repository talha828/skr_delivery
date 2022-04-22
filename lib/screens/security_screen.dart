import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:skr/Screens/MainMenu_Screen/main_menu_screen.dart';
import 'package:skr/Widgets/common.dart';
import 'package:skr/Widgets/styles.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  TextEditingController txt1,txt2,txt3,txt4;
  DateFormat format = DateFormat("ddMM");
  var date = DateTime.now();
  String code;
  String dateCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txt1=TextEditingController();
    txt2=TextEditingController();
    txt3=TextEditingController();
    txt4=TextEditingController();
    code = format.format(date);
    print(code);
  }

  getDate(){
    var date = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    var width=media.width;
    return WillPopScope(
      onWillPop: () =>  Future.value(false),
      child: SafeArea(child: Scaffold(body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          VariableText(text: "Enter the 4-digit code",
            fontsize: 16,
            textAlign: TextAlign.start,
            line_spacing: 1,
            fontcolor: textcolorblack,
            fontFamily: fontRegular,),
            SizedBox(height: height*0.005),
            VariableText(text: "DD-MM",
              fontsize: 16,
              textAlign: TextAlign.start,
              line_spacing: 1,
              fontcolor: textcolorblack,
              fontFamily: fontBold),
          SizedBox(height: height*0.01,),
          Row(
            children: [
              createCodeField(txt1,txt2),SizedBox(width: 15),
              createCodeField(txt2,txt3),SizedBox(width: 15),
              createCodeField(txt3,txt4),SizedBox(width: 15),
              createCodeField(txt4,null),
            ],
          ),
          /*OTPTextField(
            length: 4,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            fieldWidth: 40,
            style: TextStyle(
                fontSize: 16,
                fontFamily: fontRegular,
                fontWeight: FontWeight.w500
            ),
            keyboardType:TextInputType.number ,
            textFieldAlignment: MainAxisAlignment.start,
            otpFieldStyle: OtpFieldStyle(
              enabledBorderColor: Color(0xff7A7A7A),
              focusBorderColor: Color(0xff7A7A7A),
            ),
            fieldStyle: FieldStyle.underline,
            onCompleted: (pin) {
              dateCheck = pin;
              print("Completed: " + pin);
            },
          ),*/
            SizedBox(height: height*0.05),
            LoginButton(text: "Done",onTap: (){
              if(dateCheck == code){
                Navigator.pushReplacement(context, SwipeLeftAnimationRoute(widget: MainMenuScreen()));
              }else{
                Fluttertoast.showToast(msg: "Incorrect password",toastLength: Toast.LENGTH_SHORT);
              }
            },),
        ],),
      ),)),
    );
  }

  Widget createCodeField(TextEditingController cont,TextEditingController next_cont){
    return Expanded(
        child:CodeField(
            cont: cont,
            next_cont: next_cont,
          onComplete: (value){
              setState(() {
                dateCheck = txt1.text+txt2.text+txt3.text+txt4.text;
              });
              print(dateCheck);
          },
        ));
  }
}
