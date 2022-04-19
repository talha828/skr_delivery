import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:skr_delivery/screens/loginScreen/phonenumber/phonenumber.dart';

class GetStartedScreen extends StatefulWidget {

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/getstartedbottomimage.png",)),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(child: Image.asset("assets/logo.png",scale: 2,)),
                Spacer(),
                InkWell(
                  onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneNumber())),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                        color: themeColor1,
                      borderRadius: BorderRadius.circular(3)
                    ),
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(child: Container(
                            alignment: Alignment.center,
                            child: Text("Get Started",style: TextStyle(color: Colors.white,fontSize: 18),))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_rounded,color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),
        ],
      ),
    );
  }
}

