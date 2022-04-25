import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:skr_delivery/screens/splash_screen/splash_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
class NoInterNetConnection extends StatefulWidget {

  @override
  _NoInterNetConnectionState createState() => _NoInterNetConnectionState();
}

class _NoInterNetConnectionState extends State<NoInterNetConnection> {
  @override
  Widget build(BuildContext context) {
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return SafeArea(
      child: Scaffold(
        body:    DelayedDisplay(
          delay: Duration(milliseconds: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Image.asset('assets/icons/ic_nointernet.png',scale: 5.5,)),
              SizedBox(height: height*0.03,),
              VariableText(text: 'Oops, No Internet Connection',fontsize: 16,fontcolor: Color(0xff2B2B2B),),
              SizedBox(height: height*0.02,),
              VariableText(text: 'Make sure wifi or cellular data is turned on ',fontsize: 13,fontcolor: Color(0xff333333),),
              SizedBox(height: height*0.0035,),
              VariableText(text: 'and then try again.',fontsize: 13,fontcolor: Color(0xff333333),),
              SizedBox(height: height*0.025,),
              InkWell(
                onTap: (){
                  //Navigator.pop(context).checkIntetrnetConnectivtiy();
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SplashScreen()));

                },
                child: Container(
                  height: height*0.06,
                  width: width*0.35,
                  decoration: BoxDecoration(color: themeColor1,
                  borderRadius: BorderRadius.circular(55)),
                  child: Center(child: VariableText(text: ' Try Again',fontsize: 14,fontcolor: Color(0xffffffff),)),



                ),
              )

            ],
          ),
        ) ,
      ),
    );
  }
}
