import 'package:flutter/material.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/screens/main_screen/main_screen_card.dart';
import 'package:skr_delivery/screens/main_screen/main_search_field.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  List<CustomerModel> customerModel;
  double lat, long;
  SearchScreen({this.customerModel, this.lat, this.long});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  int selectedIndex = 0;
  var f = NumberFormat("###,###.0#", "en_US");
  int listLength = 0;
  bool _isSearching;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    getAllCustomerData();
    listLength = 3;
  }

  int i = 0;
  List<CustomerModel> _list = [];
  List<CustomerModel> customersearchresult = [];
  Future getAllCustomerData() async {
    for (var item in widget.customerModel) {
      if (i < widget.customerModel.length) {
        _list.add(CustomerModel(
            customerCode: item.customerCode,
            customerShopName: item.customerShopName,
            customerName: item.customerName,
            customerLatitude: item.customerLatitude,
            customerLongitude: item.customerLongitude,
            customerCreditLimit: item.customerCreditLimit,
            customerAddress: item.customerAddress,
            customerContactPersonName: item.customerContactPersonName,
            customerContactNumber: item.customerContactNumber,
            customerImage: item.customerImage,
            customerCityCode: item.customerCityCode,
            customerCityName: item.customerCityName,
            customerAreaCode: item.customerAreaCode,
            customerAreaName: item.customerAreaName,
            customerPartyCategory: item.customerPartyCategory,
            customerContactPersonName2: item.customerContactPersonName2,
            customerContactNumber2: item.customerContactNumber2,
            customerCategory: item.customerCategory,
            lastTransDay: item.lastTransDay,
            lastVisitDay: item.lastVisitDay,
            dues: item.dues,
            outStanding: item.outStanding,
            customerinfo: item.customerinfo,
            shopAssigned: item.shopAssigned,

        ));

        i++;
      } else {
        print("else work");
      }
    }
    print("customer list " + _list.length.toString());
  }

  final TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    return Scaffold(
      backgroundColor: themeColor2,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: themeColor1,

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:(){
            Navigator.pop(context);
          },
        ), //Image.asset('assets/icons/ic_commonBackIcon.png', scale: 2.1,), //
        titleSpacing: 0,
        leadingWidth: 50,
        title: VariableText(
          text: "Search Screen",
          fontsize: 16,
          fontcolor: Colors.white,
          weight: FontWeight.w600,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.025,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: MainSearchField(
                controller: _controller,
                onchange: searchOperation,

              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            customersearchresult.length != 0 || _controller.text.isNotEmpty
                ? Expanded(
              child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      //  double temp=0.01;
                      setState(() {
                        if (listLength + 1 < customersearchresult.length) {
                          listLength += 1;
                        } else {
                          int temp =
                              customersearchresult.length - listLength;
                          listLength = listLength + temp;
                        }
                      });
                      //print('temp value is'+listLength.toString());
                    }
                    if (_scrollController.position.pixels ==
                        _scrollController.position.minScrollExtent) {
                      //  print('start scroll');
                    }
                    return false;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    itemCount: customersearchresult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15),
                        child: Column(
                          children: [
                            MainScreenCards(
                              height: height,
                              width: width,
                              f: f,
                              menuButton: menuButton,
                              code: customersearchresult[index].customerCode.toString(),
                              category: customersearchresult[index].customerCategory.toString(),
                              shopName: customersearchresult[index].customerShopName.toString(),
                              address: customersearchresult[index].customerAddress.toString(),
                              name: customersearchresult[index].customerContactPersonName.toString(),
                              phoneNo: customersearchresult[index].customerContactNumber.toString(),
                              lastVisit: customersearchresult[index].lastVisitDay.toString(),
                              dues: customersearchresult[index].dues.toString(),
                              lastTrans: customersearchresult[index].lastTransDay.toString(),
                              outstanding: customersearchresult[index].outStanding.toString(),
                              shopAssigned: customersearchresult[index].shopAssigned,
                              lat: customersearchresult[index].customerLatitude,
                              long: customersearchresult[index].customerLongitude,
                              image: "",
                              customerData: widget.customerModel[index],
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
                    },
                  )),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      customersearchresult.clear();
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i].customerShopName;
        String data1 = _list[i].customerCode;

        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by name");
          customersearchresult.addAll([_list[i]]);
          setState(() {});
        }else if(data1.toLowerCase().contains(searchText.toLowerCase())) {
          print("search by code");
          customersearchresult.addAll([_list[i]]);
          setState(() {});
        }
      }
      print("result is: " + customersearchresult.length.toString());
    }
  }
}
