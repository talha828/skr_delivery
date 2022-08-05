import 'package:flutter/material.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/main_screen/main_screen_card.dart';
import 'package:skr_delivery/screens/main_screen/main_search_field.dart';
import 'package:skr_delivery/screens/search_screen/search_screen.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';

class ViewAllScreen extends StatefulWidget {
  ViewAllScreen({this.customerList,});
  List<CustomerModel> customerList;
  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  var f = NumberFormat("###,###.0#", "en_US");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor1,
        title: Text("Near by me"),
      ),
      body: Stack(
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
                                    customerModel: widget.customerList,
                                    lat: 1.00,
                                    long: 1.00,//
                                  )));
                    },
                    // enable: false,
                  ),
                 ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.customerList.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: [
                                    CustomShopContainer(
                                      customerList: widget.customerList,
                                      height: height,
                                      width: width,
                                      customerData: widget.customerList[index],
                                      //isLoading2: isLoading2,
                                      //enableLocation: _serviceEnabled,
                                      lat: 1.0,
                                      long: 1.0,
                                      showLoading: (value) {
                                        setState(() {
                                          isLoading = value;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.025,
                                    ),
                                  ],
                                ),
                              );
                            }),
                ],
              ),
            ),
          ),
          isLoading ? loader() : Container()
        ],
      ),
    );
  }
}
