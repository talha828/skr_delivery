import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/customerList.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/screens/check-in/checkin_screen.dart';
import 'dart:math' as math;
import "package:intl/intl.dart";
import 'package:skr_delivery/screens/widget/constant.dart';

class ProcessLoading extends StatefulWidget {
  @override
  State createState() {
    return _ProcessLoadingState();
  }
}

class _ProcessLoadingState extends State<ProcessLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _cont;
  Animation<Color> _anim;

  @override
  void initState() {
    _cont = AnimationController(
        duration: Duration(
          seconds: 1,
        ),
        vsync: this);
    _cont.addListener(() {
      setState(() {
        //print("val: "+_cont.value.toString());
      });
    });
    ColorTween col = ColorTween(begin: themeColor1, end: themeColor1);
    _anim = col.animate(_cont);
    _cont.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
          child: Container(
              width: 50 * _cont.value,
              height: 50 * _cont.value,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  _anim.value,
                ),
              )),
        ));
  }
}
class VariableText extends StatelessWidget {
  final String text;
  final Color fontcolor;
  final TextAlign textAlign;
  final FontWeight weight;
  final bool underlined, linethrough;
  final double fontsize, line_spacing, letter_spacing;
  final int max_lines;
   VariableText({
    this.text = "A",
    this.fontcolor = Colors.black,
    this.fontsize = 15,
    this.textAlign = TextAlign.center,
    this.weight = FontWeight.normal,
    this.underlined = false,
    this.line_spacing = 1,
    this.letter_spacing = 0,
    this.max_lines = 1,
    this.linethrough = false,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: max_lines,
      textAlign: textAlign,
      style: TextStyle(
        color: fontcolor,
        fontWeight: weight,
        height: line_spacing,
        letterSpacing: letter_spacing,
        fontSize: fontsize,
        decorationThickness: 4.0,
        decoration: underlined
            ? TextDecoration.underline
            : (linethrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}

class DashedRect extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRect(
      {this.color = Colors.black, this.strokeWidth = 1.0, this.gap = 5.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(strokeWidth / 2),
        child: CustomPaint(
          painter:
          DashRectPainter(color: color, strokeWidth: strokeWidth, gap: gap),
        ),
      ),
    );
  }
}

class DashRectPainter extends CustomPainter {
  double strokeWidth;
  Color color;
  double gap;

  DashRectPainter(
      {this.strokeWidth = 5.0, this.color = Colors.red, this.gap = 5.0});

  @override
  void paint(Canvas canvas, Size size) {
    Paint dashedPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _topPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(x, 0),
      gap: gap,
    );

    Path _rightPath = getDashedPath(
      a: math.Point(x, 0),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    Path _leftPath = getDashedPath(
      a: math.Point(0, 0),
      b: math.Point(0.001, y),
      gap: gap,
    );

    canvas.drawPath(_topPath, dashedPaint);
    canvas.drawPath(_rightPath, dashedPaint);
    canvas.drawPath(_bottomPath, dashedPaint);
    canvas.drawPath(_leftPath, dashedPaint);
  }

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
class CustomShopContainerLoading extends StatefulWidget {
  double height, width;

  CustomShopContainerLoading({
    this.height,
    this.width,
  });

  @override
  _CustomShopContainerLoadingState createState() =>
      _CustomShopContainerLoadingState();
}

class _CustomShopContainerLoadingState
    extends State<CustomShopContainerLoading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              //height: height*0.15,
              //width: widget.width * 0.83,
              //color: Colors.red,
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: widget.height * 0.0055,
                    ),
                    Container(
                      height: widget.height * 0.025,
                      width: widget.width * 0.5,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: widget.height * 0.0075,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: widget.height * 0.025,
                          width: widget.width * 0.05,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: widget.height * 0.01,
                        ),
                        Container(
                          height: widget.height * 0.025,
                          width: widget.width * 0.3,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: widget.height * 0.008,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 0.0),
                      child: Container(
                        height: 1,
                        color: Color(0xffE0E0E0),
                      ),
                    ),
                    SizedBox(
                      height: widget.height * 0.008,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.05,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: widget.height * 0.01,
                                  ),
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.2,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: widget.height * 0.01,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.05,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: widget.height * 0.01,
                                  ),
                                  Container(
                                    height: widget.height * 0.025,
                                    width: widget.width * 0.2,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0, right: 8),
                            child: Container(
                              height: widget.height * 0.035,
                              width: widget.width * 0.22,
                              decoration: BoxDecoration(
                                  color: themeColor1 /*:Color(0xff1F92F6)*/,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: VariableText(
                                  text: '',
                                  fontsize: 11,
                                  fontcolor: themeColor2,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )

          /*   Container(
            height: widget.height * 0.14,
            width: widget.width * 0.28,
            color: Colors.red,
          ),*/
        ],
      ),
    );
  }
}

class CustomShopContainer extends StatefulWidget {
  double height, width, lat, long;
  CustomerModel customerData;
  //bool isLoading2;
  //LocationData locationData;
  Function showLoading;
  List<CustomerModel> customerList;
  CustomShopContainer(
      { this.height,
        this.width,
        this.customerData,
        this.customerList,
        //this.isLoading2,
        this.lat,
        this.long,
        //this.locationData,
        this.showLoading});

  @override
  _CustomShopContainerState createState() => _CustomShopContainerState();
}

class _CustomShopContainerState extends State<CustomShopContainer> {
  /*Location location = new Location();
  bool _serviceEnabled = false;
  LocationData _locationData;*/

  double templat, templong;
  void PostEmployeeVisit(
      {String customerCode,
        String employeeCode,
        String purpose,
        String lat,
        String long,
        CustomerModel customerData}) async {
    try {
      /*   setState(() {
      widget.isLoading2=true;
    });*/
      var response = await OnlineDataBase.postEmployee(emp_id: employeeCode, customerCode: customerCode, purpose: purpose, long: long, lat: lat);
      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        print("data is" + response.data["data"]["distance"].toString());
        //  Provider.of<CartModel>(context, listen: false).createCart();
        Location location = new Location();
        var _location = await location.getLocation();
        Fluttertoast.showToast(
            msg: 'Check In Successfully',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        Provider.of<CustomerList>(context,listen: false).myCustomer(widget.customerData);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CheckIn(
                 // name: customerData.customerShopName,
                  //code:double.parse(response.data["data"]["distance"].toString()).to ,
                  //locationdata: _locationData,
                  customerData: customerData,)));
      } else {
        print("data is" + response.statusCode.toString());

        Fluttertoast.showToast(
            msg: 'Some thing went wrong',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e, stack) {
      print('exception is' + e.toString());

      Fluttertoast.showToast(
          msg: "Error: " + e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  /*void checkAndGetLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("this");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Location Denied once');
      }
    }
    _locationData = await location.getLocation();
    print("data is" + _serviceEnabled.toString());
    print("data is" + _locationData.toString());
    setState(() {
      templat = _locationData.latitude.toDouble();
      templong = _locationData.longitude.toDouble();
      print("data is" + templong.toString());
    });
  }*/

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      templat = widget.lat;
      templong = widget.long;
    });
    //print("init callling" + templat.toString());
    //print("init callling" + widget.lat.toString());
  }



  List<String> menuButton = ['DIRECTIONS', 'CHECK-IN'];
  int selectedIndex = 0;

  _onSelected(int i) {
    setState(() {
      selectedIndex = i;
    });
  }

  // getWalletStatus() async {
  //   var response2 = await OnlineDataBase.getWalletStatus();
  //   if (response2.statusCode == 200) {
  //     var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
  //     print("get wallet data is" + data2.toString());
  //     Provider.of<UserModel>(context, listen: false).getWalletStatus(data2);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
  //   }
  // }

  @override
  var f = NumberFormat("###,###.0#", "en_US");
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: themeColor2,
          boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.75))]),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: widget.height * 0.0055,
                      ),
                      Container(
                        //color: Colors.red,
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              VariableText(
                                text: '${widget.customerData.customerCode}',
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                              ),
                              VerticalDivider(
                                color: Color(0xff000000).withOpacity(0.25),
                                thickness: 1,
                              ),
                              VariableText(
                                text: widget.customerData.customerCategory,
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.01,
                      ),
                      VariableText(
                        text: widget.customerData.customerShopName,
                        fontsize: widget.height / widget.width * 7,
                        fontcolor: themeColor1,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.start,
                        max_lines: 2,
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      SizedBox(
                        height: widget.height * 0.0075,
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.customerData.customerinfo.isNotEmpty) {
                            renderDeletePopup(context, widget.height,
                                widget.width, widget.customerData);
                          } else {
                            Fluttertoast.showToast(
                                msg: "No Information found..",
                                toastLength: Toast.LENGTH_LONG);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/home.png',
                              scale: 3.5,
                              color: Color(0xff2B2B2B),
                            ),
                            SizedBox(
                              width: widget.height * 0.01,
                            ),
                            Expanded(
                              child: VariableText(
                                text: widget.customerData.customerAddress,
                                // text:shopdetails[index].address.toString(),
                                fontsize: 11,
                                fontcolor: textcolorgrey,
                                line_spacing: 1.4,
                                textAlign: TextAlign.start,
                                max_lines: 2,
                                weight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: widget.height * 0.01,
                            ),
                            Image.asset(
                              'assets/icons/more.png',
                              scale: 3,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/person.png',
                            scale: 2.5,
                            color: Color(0xff2B2B2B),
                          ),
                          SizedBox(
                            width: widget.height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: VariableText(
                              //text: 'Muhammad Ali',
                              text: widget
                                  .customerData.customerContactPersonName
                                  .toString(),
                              // text: shopdetails[index].ownerName,
                              fontsize: 11,
                              fontcolor: textcolorgrey,
                              max_lines: 1,
                              weight: FontWeight.w500,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                          Image.asset(
                            'assets/icons/contact.png',
                            scale: 2.5,
                            color: Color(0xff2B2B2B),
                          ),
                          SizedBox(
                            width: widget.height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: VariableText(
                              text: widget.customerData.customerContactNumber
                                  .toString(),
                              // text:shopdetails[index].ownerContact,
                              fontsize: 11,
                              fontcolor: textcolorgrey,

                              max_lines: 3,
                              weight: FontWeight.w500,

                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Last Visit: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.lastVisitDay.toString()=="null"?"- -":widget.customerData.lastVisitDay.toString()
                                          .toString(),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Last Trans: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,

                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.lastTransDay.toString()=="null"?"- -":widget.customerData.lastTransDay.toString()
                                          .toString(),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,

                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                          Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Dues: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.dues.toString()=="null"?"- -":f.format(double.parse(widget.customerData.dues.toString())),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: widget.height * 0.01,
                                ),
                                Row(
                                  children: [
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: 'Outstanding: ',
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: Color(0xff333333),
                                      max_lines: 1,
                                      weight: FontWeight.w600,
                                      textAlign: TextAlign.start,
                                    ),
                                    Spacer(),
                                    VariableText(
                                      //text: 'Muhammad Ali',
                                      text: widget.customerData.outStanding.toString()=="null"?"- -":f.format(double.parse(widget.customerData.outStanding.toString())),
                                      // text: shopdetails[index].ownerName,
                                      fontsize: 11,
                                      fontcolor: textcolorgrey,
                                      max_lines: 1,
                                      weight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0.0),
                        child: Container(
                          height: 1,
                          width: widget.width,
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      SizedBox(
                        height: widget.height * 0.008,
                      ),
                      Row(
                          children: List.generate(menuButton.length, (index) {
                            return InkWell(
                                onTap: () async {
                                  widget.showLoading(true);
                                  _onSelected(index);
                                  if (index == 1) {
                                    if (templat == null) {
                                      Fluttertoast.showToast(
                                          msg: 'Please Enable Your Location',
                                          toastLength: Toast.LENGTH_SHORT,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      widget.showLoading(false);
                                      //checkAndGetLocation();
                                    } else {
                                      if("Yes"=="Yes"){
                                        Location location = new Location();
                                        var _location = await location.getLocation();
                                        await PostEmployeeVisit(
                                            employeeCode: userData.userEmpolyeeNumber,
                                            customerCode: widget.customerData.customerCode,
                                            purpose: 'Check In',
                                            lat: _location.latitude.toString(),
                                            long: _location.longitude.toString(),
                                            customerData: widget.customerData);
                                      }
                                      widget.showLoading(false);

                                      // if('Yes' == 'Yes'){
                                      //   if (double.parse(userData.usercashReceive) >=
                                      //       double.parse(userData.usercashLimit)
                                      //   // || double.parse(userData.usercashReceive) < 0
                                      //   ) {
                                      //     limitReachedPopup(
                                      //         context: context,
                                      //         height: widget.height,
                                      //         width: widget.width);

                                      ///for testing
                                      /*widget.showLoading(true);
                                    await PostEmployeeVisit(
                                        customerCode:
                                            widget.customerData.customerCode,
                                        purpose: 'Check In',
                                        lat: templat.toString(),
                                        long: templong.toString(),
                                        customerData: widget.customerData);
                                    widget.showLoading(false);*/
                                      // } else {

                                      //   //TODO:// set check-in api
                                      //   // widget.showLoading(true);
                                      //   // await PostEmployeeVisit(
                                      //   //     customerCode:
                                      //   //     widget.customerData.customerCode,
                                      //   //     purpose: 'Check In',
                                      //   //     lat: templat.toString(),
                                      //   //     long: templong.toString(),
                                      //   //     customerData: widget.customerData);
                                      //   // widget.showLoading(false);
                                      // }
                                      // }
                                    }
                                  } else if (index == 0) {
                                    ///Launch Map
                                    if (widget.customerData.customerLatitude ==
                                        null) {
                                      Fluttertoast.showToast(
                                          msg: "Shop location not found",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Colors.black87,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      if (await MapLauncher.isMapAvailable(
                                          MapType.google)) {
                                        await MapLauncher.showMarker(
                                          mapType: MapType.google,
                                          coords: Coords(
                                              widget.customerData.customerLatitude,
                                              widget
                                                  .customerData.customerLongitude),
                                          title:
                                          widget.customerData.customerShopName,
                                          description:
                                          widget.customerData.customerAddress,
                                        );
                                      }
                                      widget.showLoading(false);
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: widget.height * 0.05,
                                      width: widget.width * 0.38,
                                      decoration: BoxDecoration(
                                          color: index == 0
                                              ? themeColor1
                                              : themeColor2,
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(
                                              color: index == 0 ?
                                              themeColor1
                                                  : 'Yes' == 'Yes' ? themeColor1 : Colors.grey[400]
                                          )),
                                      child: Center(
                                        child: VariableText(
                                          text: menuButton[index],
                                          fontsize: 11,
                                          fontcolor: index == 0
                                              ? themeColor2
                                              : 'Yes' == 'Yes' ? themeColor1 : Colors.grey[400],
                                          weight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }))
                    ],
                  ),
                ),
              ),
            ),
            /*  Container(
              height: widget.height * 0.14,
              width: widget.width * 0.28,
              */ /*          decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0]),
                   // image: AssetImage('assets/images/shop1.jpg'),
                    fit: BoxFit.fill,

                ),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(5),

              ),*/ /*
              child: Image.network(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0],
                 fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
                */ /*
                 Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                child: Container(
                  height: widget.height * 0.14,
                  width: widget.width * 0.28,
                 color: Colors.red,
                ),)*/ /*
              }),
            ),*/
          ],
        ),
      ),
    );

    ///old ui
    /*  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: themeColor2,
          boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.25))]),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
         Expanded(child:   Container(
           //height: height*0.15,
           // width: widget.width * 0.85,
           //color: Colors.red,
           child: Padding(
             padding: EdgeInsets.only(left: 8.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   height: widget.height * 0.0055,
                 ),
                 VariableText(
                   text: widget.customerData.customerShopName,
                   fontsize: widget.height / widget.width * 7,
                   fontcolor: themeColor1,
                   weight: FontWeight.w700,
                   fontFamily: fontRegular,
                   textAlign: TextAlign.start,
                   max_lines: 2,
                 ),
                 SizedBox(
                   height: widget.height * 0.0075,
                 ),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Image.asset(
                       'assets/icons/home.png',
                       scale: 3.5,
                       color: Color(0xff2B2B2B),
                     ),
                     SizedBox(
                       width: widget.height * 0.01,
                     ),
                     Expanded(
                       child: VariableText(
                         text: widget.customerData.customerAddress,
                         // text:shopdetails[index].address.toString(),
                         fontsize: 11,
                         fontcolor: textcolorgrey,
                         line_spacing: 1.4,
                         textAlign: TextAlign.start,
                         max_lines: 2,
                         weight: FontWeight.w500,
                         fontFamily: fontRegular,
                       ),
                     ),
                   ],
                 ),
                 SizedBox(
                   height: widget.height * 0.008,
                 ),
                 Padding(
                   padding: EdgeInsets.only(right: 0.0),
                   child: Container(
                     height: 1,
                     width: widget.width,
                     color: Color(0xffE0E0E0),
                   ),
                 ),
                 SizedBox(
                   height: widget.height * 0.008,
                 ),
                 Row(
                   children: [
                     Expanded(
                       flex: 12,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Image.asset(
                                 'assets/icons/person.png',
                                 scale: 2.5,
                                 color: Color(0xff2B2B2B),
                               ),
                               SizedBox(
                                 width: widget.height * 0.01,
                               ),
                               Expanded(
                                 //width:width*0.10,
                                 child: Padding(
                                   padding: EdgeInsets.only(top: 4.0),
                                   child: VariableText(
                                     //text: 'Muhammad Ali',
                                     text: widget.customerData
                                         .customerContactPersonName
                                         .toString(),
                                     // text: shopdetails[index].ownerName,
                                     fontsize: 11,
                                     fontcolor: textcolorgrey,
                                     max_lines: 1,
                                     weight: FontWeight.w500,
                                     textAlign: TextAlign.start,
                                     fontFamily: fontRegular,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(
                             height: widget.height * 0.01,
                           ),
                           Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Image.asset(
                                 'assets/icons/contact.png',
                                 scale: 2.5,
                                 color: Color(0xff2B2B2B),
                               ),
                               SizedBox(
                                 width: widget.height * 0.01,
                               ),
                               Padding(
                                 padding: EdgeInsets.only(top: 2.0),
                                 child: VariableText(
                                   text: widget
                                       .customerData.customerContactNumber
                                       .toString(),
                                   // text:shopdetails[index].ownerContact,
                                   fontsize: 11,
                                   fontcolor: textcolorgrey,

                                   max_lines: 3,
                                   weight: FontWeight.w500,
                                   fontFamily: fontRegular,
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),
                     // Spacer(),
                     Expanded(
                       flex: 7,
                       child: Padding(
                         padding: const EdgeInsets.only(top: 12.0, right: 8),
                         child: InkWell(
                           onTap: () async {
                             //PostEmployeeVisit(customerCode:widget.customerData.customerCode,purpose: 'Check In',lat: widget.lat.toString(),long: widget.long.toString(),customerData:widget.customerData );
                             if (templat == null) {
                               print("lat log in" +
                                   templong.toString() +
                                   templat.toString());
                               Fluttertoast.showToast(
                                   msg: 'Please Enable Your Location',
                                   toastLength: Toast.LENGTH_SHORT,
                                   backgroundColor: Colors.black87,
                                   textColor: Colors.white,
                                   fontSize: 16.0);
                               checkAndGetLocation();
                             } else {
                               if(int.parse(userData.usercashReceive)>=int.parse(userData.usercashLimit)  ||int.parse(userData.usercashReceive)<0 ){
                                 limitReachedPopup(context:context,height:widget.height,width:widget.width);
*/ /*
                                 ///for testing
                                 widget.showLoading(true);
                                 await PostEmployeeVisit(
                                     customerCode:
                                     widget.customerData.customerCode,
                                     purpose: 'Check In',
                                     lat: templat.toString(),
                                     long: templong.toString(),
                                     customerData: widget.customerData);
                                 widget.showLoading(false);*/ /*
                               }
                           else{
                                 widget.showLoading(true);
                                 await PostEmployeeVisit(
                                     customerCode:
                                     widget.customerData.customerCode,
                                     purpose: 'Check In',
                                     lat: templat.toString(),
                                     long: templong.toString(),
                                     customerData: widget.customerData);
                                 widget.showLoading(false);
                               }
                             }
                           },
                           child: Container(
                             height: widget.height * 0.035,
                             width: widget.width * 0.22,
                             decoration: BoxDecoration(
                                 color: themeColor1 */ /*:Color(0xff1F92F6)*/ /*,
                                 borderRadius: BorderRadius.circular(5)),
                             child: Center(
                               child: VariableText(
                                 text: 'Check In',
                                 fontsize: 11,
                                 fontcolor: themeColor2,
                                 weight: FontWeight.w700,
                                 fontFamily: fontRegular,
                               ),
                             ),
                           ),
                         ),
                       ),
                     )
                   ],
                 )
               ],
             ),
           ),
         ),),
          */ /*  Container(
              height: widget.height * 0.14,
              width: widget.width * 0.28,
              */ /**/ /*          decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0]),
                   // image: AssetImage('assets/images/shop1.jpg'),
                    fit: BoxFit.fill,

                ),
                // color: Colors.red,
                borderRadius: BorderRadius.circular(5),

              ),*/ /**/ /*
              child: Image.network(widget.customerData.customerImage.toString()=="No Image"?"https://i.stack.imgur.com/y9DpT.jpg":widget.customerData.customerImage.split('{"')[1].split('"}')[0],
                 fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
                */ /**/ /*
                 Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: true,
                child: Container(
                  height: widget.height * 0.14,
                  width: widget.width * 0.28,
                 color: Colors.red,
                ),)*/ /**/ /*
              }),
            ),*/ /*
          ],
        ),
      ),
    );*/
  }

// limitReachedPopup({BuildContext context, double height, double width}) {
//   AwesomeDialog(
//       context: context,
//       //dismissOnTouchOutside: false,
//       animType: AnimType.SCALE,
//       dialogType: DialogType.WARNING,
//       btnOkColor: themeColor1,
//       showCloseIcon: true,
//       btnOkText: "OK",
//       closeIcon: Icon(Icons.close),
//       btnOkOnPress: () {
//         print("ok tap");
//         // Navigator.pop(context);
//       },
//       body: StatefulBuilder(builder: (context, setState) {
//         return Container(
//           width: width,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: [
//               VariableText(
//                 text: "Your Limit is Reached",
//                 fontsize: 14,
//                 fontcolor: textcolorblack,
//                 weight: FontWeight.w500,
//                 fontFamily: fontMedium,
//               ),
//               // SizedBox(height: height*0.02,),
//             ],
//           ),
//         );
//       }))
//     ..show();
// }
//
// void PostEmployeeVisit(
//     {String customerCode,
//       String purpose,
//       String lat,
//       String long,
//       CustomerModel customerData}) async {
//   try {
//     /*   setState(() {
//     widget.isLoading2=true;
//   });*/
//     var response = await OnlineDataBase.postEmployeeVisit(
//         customerCode: customerCode, purpose: purpose, long: long, lat: lat);
//     print("Response is" + response.statusCode.toString());
//     if (response.statusCode == 200) {
//       var data = jsonDecode(utf8.decode(response.bodyBytes));
//       print("data is" + data.toString());
//       Fluttertoast.showToast(
//           msg: 'Check In Successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           backgroundColor: Colors.black87,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       //Provider.of<CartModel>(context, listen: false).createCart();
//       Provider.of<RetrunCartModel>(context, listen: false).retruncreateCart();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (_) => CheckInScreen(
//                   customerList: widget.customerList,
//                   //locationdata: _locationData,
//                   shopDetails: customerData,
//                   long: templong,
//                   lat: templat))).then((value) {
//         initPage();
//       });
//     } else {
//       print("data is" + response.statusCode.toString());
//
//       Fluttertoast.showToast(
//           msg: 'Some thing went wrong',
//           toastLength: Toast.LENGTH_SHORT,
//           backgroundColor: Colors.black87,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   } catch (e, stack) {
//     print('exception is' + e.toString());
//
//     Fluttertoast.showToast(
//         msg: "Something went wrong try again letter",
//         toastLength: Toast.LENGTH_SHORT,
//         backgroundColor: Colors.black87,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
// }
}
renderDeletePopup(BuildContext context, double height, double width,
    CustomerModel customerData) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 100),
    context: context,
    pageBuilder: (_, __, ___) {
      return PopupWithHeader(
        height: height,
        width: width,
        customerData: customerData,
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        //position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
class PopupWithHeader extends StatelessWidget {
  double height;
  double width;
  CustomerModel customerData;
  PopupWithHeader({this.height, this.width, this.customerData});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            height: height * 0.50,
            width: width * 0.90,
            color: Colors.transparent,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.04),
                  child: Container(
                    height: height * 0.50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.07,
                          ),
                          VariableText(
                            text: "Customer Information",
                            fontsize: 18,
                            weight: FontWeight.w600,
                            fontcolor: Color(0xff1F1F1F),
                          ),
                          SizedBox(
                            height: height * 0.0075,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 0.0),
                            child: Container(
                              height: 1,
                              width: width,
                              color: Color(0xffE0E0E0),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: width * 0.5,
                              child: ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: customerData.customerinfo.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return customRow(
                                        title1:
                                        customerData.customerinfo[index].key,
                                        title2:
                                        customerData.customerinfo[index].value);
                                  }),
                            ),
                          ),
                          /* customRow(title1: 'Kashif',title2: '0321-333-4556'),
                          customRow(title1: 'Last Visit Date',title2: '12-Dec-21'),
                          customRow(title1: 'Last Visit',title2: 'Delivery'),
                          customRow(title1: 'Last Trans Date',title2: '15-Dec-21'),
                          customRow(title1: 'Last Trans Amount',title2: '3000'),
                          customRow(title1: 'Due Days',title2: '3'),*/

                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: height * 0.05,
                              width: width * 0.30,
                              decoration: BoxDecoration(
                                  color: themeColor1,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: VariableText(
                                  text: "Close",
                                  fontsize: 18,
                                  fontcolor: themeColor2,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: height * 0.1,
                    width: height * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: themeColor1, width: 2),
                        borderRadius: BorderRadius.circular(55)),
                    child: Center(
                        child: Image.asset(
                          "assets/icons/i.png",
                          scale: 4.2,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customRow({String title1, title2}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VariableText(
              text: title1,
              fontsize: 14,
              weight: FontWeight.w500,
              fontcolor: Color(0xff333333),
            ),
            VariableText(
              text: title2,
              textAlign: TextAlign.center,
              fontsize: 14,
              fontcolor: Color(0xff828282),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.015,
        )
      ],
    );
  }
}
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  Color color, color2;
  Function ontap;

  MyAppBar(
      {this.title,
        this.ontap,
        this.color = themeColor1,
        this.color2 = Colors.white});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double ratio = height / width;

    return AppBar(
      iconTheme: IconThemeData(color: textcolorblack),
      elevation: 0.5,
      backgroundColor: widget.color,

      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: widget.ontap,
      ), //Image.asset('assets/icons/ic_commonBackIcon.png', scale: 2.1,), //
      titleSpacing: 0,
      leadingWidth: 50,
      title: VariableText(
        text: widget.title,
        fontsize: 16,
        fontcolor: widget.color2,
        weight: FontWeight.w600,
      ),
    );
  }
}