import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:skr_delivery/screens/EditShop/edit_shop.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';

class CustomerInfo extends StatelessWidget {
  CustomerInfo({this.height,this.code,this.name,this.image,this.location,this.shopDetails,this.long,this.lat});

  final double height;
  final code;
  final name;
  final image;
  final location;
  final lat;
  final long;
  final shopDetails;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xffE0E0E099).withOpacity(0.6),
        )
      ], color: themeColor2),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: height * 0.08,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LayoutBuilder(
                    builder: (_, constraints) => Image.network(
                      image,
                      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                        return Image.asset("assets/icons/person.png",color: themeColor1,);
                      },
                      //   widget.shopDetails.customerImage
                      //       .toString() ==
                      //       "No Image" ||
                      //       widget.shopDetails.customerImage ==
                      //           null
                      //       ? "https://i.stack.imgur.com/y9DpT.jpg"
                      //       : widget.shopDetails.customerImage
                      //       .split('{"')[1]
                      //       .split('"}')[0],
                      fit: BoxFit.fill,
                      // loadingBuilder:
                      //   (BuildContext context, Widget child,
                      //   ImageChunkEvent loadingProgress) {
                      // if (loadingProgress == null) return child;
                      // return Center(
                      //   child: CircularProgressIndicator(
                      //     value: loadingProgress
                      //         .expectedTotalBytes !=
                      //         null
                      //         ? loadingProgress
                      //         .cumulativeBytesLoaded /
                      //         loadingProgress.expectedTotalBytes
                      //         : null,
                      //   ),
                      // );

                      // }
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                //width: width*0.70,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: height*0.0055,),
                      VariableText(
                        text: name,
                        // text: widget.shopDetails.customerShopName
                        //     .toString(),
                        //text: widget.shopDetails['name'],
                        fontsize: 15, fontcolor: textcolorblack,
                        weight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: VariableText(
                                text: code,
                                // text: widget
                                //     .shopDetails.customerCode
                                //     .toString(),
                                // text: widget.shopDetails['address'],
                                fontsize: 14,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.1,
                                textAlign: TextAlign.start,
                                max_lines: 5,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.008,
                      ),
                    ],
                  ),
                ),
              ),

            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: ()=>
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'No access',
                  btnOkOnPress: () {},
                )..show(),

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => EditShopScreen(
                  //           lat: lat,
                  //           long: long,
                  //           shopData: shopDetails,
                  //           locationdata: location,
                  //         )));

                child: Container(
                  height: height * 0.045,
                  decoration: BoxDecoration(
                      color: Colors.grey /*:Color(0xff1F92F6)*/,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: VariableText(
                        text: 'Edit Shop',
                        fontsize: 11,
                        fontcolor: themeColor2,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}