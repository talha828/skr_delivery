import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';


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
            ),
            SizedBox(height: height*0.005),
            VariableText(text: "DD-MM",
              fontsize: 16,
              textAlign: TextAlign.start,
              line_spacing: 1,
            ),
          SizedBox(height: height*0.01,),
          Row(
            children: [
              createCodeField(txt1,txt2),SizedBox(width: 15),
              createCodeField(txt2,txt3),SizedBox(width: 15),
              createCodeField(txt3,txt4),SizedBox(width: 15),
              createCodeField(txt4,null),
            ],
          ),
            SizedBox(height: height*0.05),
            LoginButton(text: "Done",onTap: (){
              if(dateCheck == code){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(check: true,)));
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
class CodeField extends StatelessWidget{

  final TextEditingController cont,next_cont;
  final String hinttext;
  // final Widget icon;
  final bool texthidden,readonly;
  final TextAlign textAlign;
  Function onComplete;

  CodeField({this.cont,this.hinttext,this.texthidden=false,this.readonly=false,
    //this.icon,
    this.onComplete,
    this.next_cont, this.textAlign=TextAlign.center,});

  @override
  Widget build(BuildContext context) {

    double radius=10;

    return TextField(
      onChanged: (x){
        print("onchange");
        if(cont.text.isNotEmpty){
          FocusScope.of(context).nextFocus();
        }else{
          FocusScope.of(context).previousFocus();
        }
        if(next_cont!=null) {
          next_cont.text = "";
        }
        onComplete(x);
      },
      controller: cont,
      maxLength: 1,
      obscureText: texthidden,
      readOnly: readonly,
      textAlign: textAlign,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 18,//fontFamily: fontNormal
      ),
      decoration: InputDecoration(counterText: "",
        contentPadding: EdgeInsets.only(top: 10,bottom: 10,left: 2),
        border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(radius)
        ),
        enabledBorder:OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0),
                width: 1),
            borderRadius: BorderRadius.circular(radius)
        ),
        fillColor: Colors.white,
        // fillColor: Colors.black,
        filled: true,
        hintText: hinttext,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool enable;
  final double width;
  const LoginButton(
      {this.text = "temp", this.onTap, this.enable = true, this.width});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;

    double radius = 4;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: themeColor1,
          borderRadius: BorderRadius.circular(radius),
        ),
        height: 50,
        width: width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  VariableText(
                    text: text,
                    textAlign: TextAlign.center,
                    fontsize: 15,
                    fontcolor: themeColor2,
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward,color: Colors.white,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}