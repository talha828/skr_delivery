import 'package:flutter/material.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/main_screen/main_screen_card.dart';
import 'package:skr_delivery/screens/main_screen/main_search_field.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';
class ViewAllScreen extends StatefulWidget {
  ViewAllScreen({this.nearByCustomers,this.customerList,this.lat,this.long});
  final nearByCustomers;
  final customerList;
  final lat;
  final long;
  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  var f = NumberFormat("###,###.0#", "en_US");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor1,
        title: Text("Near by me"),
      ),
      body:Stack(
        alignment: Alignment.center,
        children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                MainSearchField(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SearchScreen(
                              customerModel:widget.customerList ,
                              lat: widget.lat,
                              long: widget.long,
                            )));
                  },
                  // enable: false,
                ),
                Container(
                  child: widget.nearByCustomers.length<10?Container(
                    height: 380,
                    child: Center(child: Text("No Shop Found")),
                  ):ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder:(context,index){
                        return  MainScreenCards(
                          height: height,
                          width: width,
                          f: f,
                          menuButton: menuButton,
                          code: widget.nearByCustomers[index].customerCode.toString(),
                          category: widget.nearByCustomers[index].customerCategory.toString(),
                          shopName: widget.nearByCustomers[index].customerShopName.toString(),
                          address: widget.nearByCustomers[index].customerAddress.toString(),
                          name: widget.nearByCustomers[index].customerContactPersonName.toString(),
                          phoneNo: widget.nearByCustomers[index].customerContactNumber.toString(),
                          lastVisit: widget.nearByCustomers[index].lastVisitDay.toString(),
                          dues: widget.nearByCustomers[index].dues.toString(),
                          lastTrans: widget.nearByCustomers[index].lastTransDay.toString(),
                          outstanding: widget.nearByCustomers[index].outStanding.toString(),
                          shopAssigned: widget.nearByCustomers[index].shopAssigned,
                          lat: widget.nearByCustomers[index].customerLatitude,
                          long: widget.nearByCustomers[index].customerLongitude,
                          showLoading: (value) {
                            setState(() {
                              isLoading = value;
                            });
                          },
                        );
                      } ),
                )
              ],
            ),
          ),
        ),
          isLoading?loader():Container()
      ],),
    );
  }
}
