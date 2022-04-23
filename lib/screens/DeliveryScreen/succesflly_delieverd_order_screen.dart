import 'package:flutter/material.dart';
import 'package:skr_delivery/screens/check-in/checkin_screen.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';


class SucessFullyDelieveredOrderScreen extends StatefulWidget {
  final shopDetails;
  var lat,long;
  SucessFullyDelieveredOrderScreen({this.shopDetails,this.lat,this.long});
  @override
  _SucessFullyDelieveredOrderScreenState createState() => _SucessFullyDelieveredOrderScreenState();
}

class _SucessFullyDelieveredOrderScreenState extends State<SucessFullyDelieveredOrderScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<bool> _onWillPop(){
    // Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)));
    return   Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xffFFEEE0),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.07,),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckIn(customerData: widget.shopDetails,code: widget.shopDetails.code,name: widget.shopDetails.shopName,image: "No Image",)));
                      },
                    child: Image.asset(
                      "assets/icons/cross.png",
                      scale: 3.5,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: Image.asset(
                  "assets/icons/checked.png",
                  scale: 3,
                ),
              ),
              SizedBox(
                height: height * 0.03,),
              Center(
                child: VariableText(
                  text: "Order Delivered Successfully",
                  fontsize: 18,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  weight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: height * 0.015,),
              Center(
                child: VariableText(
                  text: "Congratulations, Your Order has been",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  weight: FontWeight.w400,
                ),
              ),

              Center(
                child: VariableText(
                  text: " delivered  successfully. ",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,
                  weight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: height * 0.02,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));
                },
                child: Center(
                  child: Container(
                    height: height*0.06,
                    width: width*0.50,
                    decoration: BoxDecoration(
                      color: themeColor1,
                      borderRadius: BorderRadius.circular(4),

                    ),

                    child:   Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: VariableText(
                          text: 'CONTINUE',
                          weight: FontWeight.w700,
                          fontsize: 16,
                          fontcolor: themeColor2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Spacer(),





            ],
          ),
        ),

      ),
    );
  }
}
