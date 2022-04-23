import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/model/retrun_cart_model.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';


class SucessFullyReturnScreen extends StatefulWidget {
  final shopDetails;
  var lat,long;
  SucessFullyReturnScreen({this.shopDetails,this.lat,this.long});
  @override
  _SucessFullyReturnScreenState createState() => _SucessFullyReturnScreenState();
}

class _SucessFullyReturnScreenState extends State<SucessFullyReturnScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<bool> _onWillPop(){
    // return   Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    var width = media.width;
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
        backgroundColor: themeColor1.withOpacity(0.25),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height*0.08,),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      Provider.of<RetrunCartModel>(context, listen: false).retruncreateCart();
                      // Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)));
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
                  text: "Return Request!",
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
                  text: "Return request against your order",
                  fontsize: 15,
                  textAlign: TextAlign.start,
                  line_spacing: 1,

                  weight: FontWeight.w400,
                ),
              ),

              Center(
                child: VariableText(
                  text: "has been generated",
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
                  Provider.of<RetrunCartModel>(context, listen: false).retruncreateCart();
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>CheckInScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,fromShop: true,)));

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




            ],
          ),
        ),

      ),
    );
  }
}
