import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/model/area_model.dart';
import 'package:skr_delivery/model/city_model.dart';
import 'package:skr_delivery/model/partycategories.dart';
import 'package:skr_delivery/model/retrun_cart_model.dart';
import '../model/box_model.dart';
import '../model/delivery_model.dart';
import 'online_auth.dart';
import 'package:http/http.dart' as http;

int _secs = 20;
const String _timeoutString = "Response Timed Out";
const String _something = 'Something went wrong';
String phoneNumber;
String phonepass;
String smsApiKey = '95baf232c5ccb5c760b8862c5ffac854';

class OnlineDataBase {
  static Future<dynamic> getAllCustomer() async {
    String url = directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_datatype=INFO';
    print("url is: " + url);
    //TODO set phone number and password
    final response = await http.get(Uri.parse(url));
    return response;
  }
  static Future<dynamic> getAssignShop() async {
    String url = directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+923163301494&pin_password=555&pin_datatype=DELIVERYMAN';//TODO num, pass
    print("url is: " + url);
    //TODO set phone number and password
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<dynamic> getImage() async {
    String url = directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass';
    print("url is: " + url);
    //TODO set phone number and password
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<dynamic> getTranactionDetails({String customerCode}) async {
    var url = Uri.parse(directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_datatype=CRLB');
    print('getTranactionDetails url is: ' + url.toString());
    final response = await http.get(url);
    return response;
  }

  static Future<dynamic> getDeliveryDetails(
      {String customercode,
      String dataType,
      String orderId,
      bool showFullDetails}) async {
    var url = Uri.parse(showFullDetails
        ? directory +
            'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customercode&pin_datatype=$dataType&pin_order_no=$orderId'
        : directory +
            'gettransactions?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customercode&pin_datatype=$dataType');
    print("get delivery details url is" + url.toString());
    final response = await http.get(url);
    return response;
  }

  static Future<dynamic> getBoxDeliveries(
      {String customercode, String dataType}) async {
    var url = Uri.parse(directory +
        'getorders?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customercode&pin_datatype=$dataType');
    print("get delivery details url is: " + url.toString());
    final response = await http.get(url);
    return response;
  }

  static Future<dynamic> postDeliverDetails(
      {List<DeliveryModel> deliverydata,
      String customerCode,
      String lat,
      String long,
      String orderNumber}) async {
    // var url =Uri.parse(directory+ 'postdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_order_no=$orderNumber&file_type=json&file_name=');
    var url = Uri.parse(directory +
        'postdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_order_no=$orderNumber&file_type=json&file_name=');
    print("post delivery order url is: " + url.toString());

    Map<String, dynamic> postData = {"Orderitems": []};
    for (int i = 0; i < deliverydata.length; i++) {
      postData['Orderitems'] += [
        {
          "Prod_code": deliverydata[i].productCode,
          "OrderLine": deliverydata[i].orderLine,
          "Qty": deliverydata[i].quantity,
          "Rate": deliverydata[i].rate,
          "Amount": deliverydata[i].quantity * deliverydata[i].rate,
        },
      ];
    }
    print("post data is: " + jsonEncode(postData));
    final response = await http.post(
      url,
      body: jsonEncode(postData),
    );
    return response;
  }

  static Future<dynamic> postBoxDeliverDetails(
      {BoxModel boxDetails,
      String customerCode,
      String lat,
      String long}) async {
    var url = Uri.parse(directory +
        'postboxdelivery?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_box_tr=${boxDetails.trNumber}');
    print("post box delivery url is: " + url.toString());

    final response = await http.post(
      url,
    );
    return response;
  }



  static Future<dynamic> postPayment(
      {String customerCode,
      String imageUrl,
      String lat,
      String long,
      String paymentMode,
      String checkNumber,
      String amount,
      String name,
      String date}) {
    String url = paymentMode == '1'
        ? directory +
            'postcollection?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&pin_pay_mode=$paymentMode&pin_cheq_date=&pin_amount=$amount&pin_rcvd_from=$name&file_type&file_name'
        : directory +
            'postcollection?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_image_url=${imageUrl}&pin_longitude=$long&pin_latitude=$lat&pin_pay_mode=$paymentMode&pin_cheq=$checkNumber&pin_cheq_date=$date&pin_amount=$amount&pin_rcvd_from=$name&file_type&file_name';

    print("post payment method url is: " + url);
    try {
      var response = http.post(Uri.parse(url), body: null);
      return response;
    } catch (e) {
      print("exception in post payment api is");
    }
  }

  static Future<dynamic> uploadImage({String type, var image}) async {
    Dio dio = new Dio();

    var url = 'https://suqexpress.com/api/uploadimage';
    print("Url is: " + url.toString());
    try {
      FormData postData = new FormData.fromMap({
        "type": type,
      });
      postData.files.add(MapEntry("image", image));

      var response = await dio.post(url,
          data: postData,
          options: Options(contentType: 'multipart/form-data; boundary=1000'));
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      e.toString();
      return false;
    }
  }

  static Future<dynamic> postReturnOrder(
      {RetrunCartModel cartData,
      String customerCode,
      String lat,
      String long}) async {
    var url = Uri.parse(directory +
        'postsalesreturn?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_longitude=$long&pin_latitude=$lat&file_type=json&file_name=');
    print("post Sales return url is" + url.toString());

    Map<String, dynamic> postData = {"Orderitems": []};
    for (var item in cartData.returncartItemName) {
      postData['Orderitems'] += [
        {
          "Prod_code": item.productName.productCode.toString(),
          "Qty": item.itemCount,
          "Rate": item.itemPrice,
          "Amount": item.itemCount * item.itemPrice
        },
      ];
    }
    Map<String, dynamic> temp = {"Orderitems": []};
    List<ReturnCartItem> templist = [];

    for (int i = 0; i < cartData.returncartItemName.length; i++) {
      bool isExist = false;
      print("data is" +
          cartData.returncartItemName[i].productName.productCode.toString());
      int totalCount = cartData.returncartItemName[i].itemCount;
      for (int j = i + 1;
          i < cartData.returncartItemName.length &&
              j < cartData.returncartItemName.length;
          j++) {
        if (cartData.returncartItemName[i].productName.productCode ==
            cartData.returncartItemName[j].productName.productCode) {
          totalCount += cartData.returncartItemName[j].itemCount;
        }
      }
      print(totalCount.toString());
      for (int k = 0; k < templist.length; k++) {
        if (templist[k].productName.productCode ==
            cartData.returncartItemName[i].productName.productCode) {
          isExist = true;
        }
      }
      if (!isExist) {
        templist.add(cartData.returncartItemName[i]);
        temp['Orderitems'] += [
          {
            "Prod_code": cartData.returncartItemName[i].productName.productCode
                .toString(),
            "Qty": totalCount,
            "Rate": cartData.returncartItemName[i].itemPrice,
            "Amount": totalCount * cartData.returncartItemName[i].itemPrice
          },
        ];
      }
    }
    print("length is" + cartData.returncartItemName.length.toString());
    print("post data is" + temp.toString());

    final response = await http.post(
      url,
      body: jsonEncode(temp),
    );
    return response;
  }

  static Future<dynamic> getAllPrdouct() async {
    var url = Uri.parse(directory +
        'getprodprice?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=pin_cust_code');
    print("get product url is " + url.toString());
    final response = await http.get(
        // Uri.parse(directory+'getproducts?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=pin_cust_code'));
        url);
    return response;
  }

  static Future<dynamic> getSingleCustomer(String custCode) async {
    String url = directory +
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_datatype=&pin_cust_code=$custCode';
    print("url is: " + url);
    final response = await http.get(Uri.parse(url));
    return response;
  }

  static Future<List<City>> getAllCities({Function task}) async {
    List<City> cities;
    var url = Uri.parse(directory +
        'getcities?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_city_code=');
    print("get city url: " + url.toString());
    await http.get(url).then((response) {
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print("data is: "+data.toString());
        var datalist = data['results'];
        if (datalist != null) {
          cities = [];
          for (var item in data['results']) {
            City city = City(
                cityCode: (item["CITY_CODE"].toString()),
                cityName: item["CITY"],
                cityNickName: item["NICK_NAME"],
                cityDialCode: item["DIAL_CODE"],
                cityCountryName: item["COUNTRY"]);
            cities.add(city);
          }
        } else if (response.statusCode == 204 || response.statusCode == 404) {
          Fluttertoast.showToast(
              msg: "City  not found", toastLength: Toast.LENGTH_LONG);
        } else {
          String msg = data["message"]
              .toString()
              .replaceAll("{", "")
              .replaceAll("}", "")
              .replaceAll(",", "\n");
          Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
        }
      }
    }).catchError((ex, stack) {
      print("exception iss" + ex.toString() + stack.toString());
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs), onTimeout: () {
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return cities;
  }

  static Future<List<PartyCategories>> getPartyCategories() async {
    List<PartyCategories> partyCategories;
    var url = Uri.parse(directory +
        'getpartycategories?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cat_code=');
    print("get getPartyCategories url: " + url.toString());
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print("data is: " + data.toString());
        var datalist = data['results'];
        if (datalist != null) {
          partyCategories = [];
          for (var item in data['results']) {
            PartyCategories partyCategorie = PartyCategories(
              partyCategoriesCode: (item["CAT_CODE"].toString()),
              partyCategoriesName: item["CATEGORY"],
            );
            partyCategories.add(partyCategorie);
          }
        }
      } else if (response.statusCode == 204 || response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "Party Categories  not found", toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(msg: _something, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex, stack) {
      print("exception iss" + ex.toString() + stack.toString());
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs), onTimeout: () {
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return partyCategories;
  }

  static Future<List<Area>> getAreaByCity(cityID) async {
    List<Area> areas;
    var url = Uri.parse(directory +
        'getcityareas?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_city_code=$cityID');
    print("get city url: " + url.toString());
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print("data is"+data.toString());
        var datalist = data['results'];
        //print("data is"+datalist.toString());
        if (datalist != null) {
          areas = [];
          for (var item in data['results']) {
            Area area = Area(
                areaCode: (item["AREA_CODE"].toString()),
                areaName: item["AREA_NAME"],
                areacityCode: (item["CITY_CODE"].toString()),
                areacityName: item["CITY"],
                areacityNickName: item["NICK_NAME"],
                areacityDialCode: item["DIAL_CODE"],
                areacityCountryName: item["COUNTRY"]);
            areas.add(area);
            // print("area is" + areas.toString());
          }
        }
      } else if (response.statusCode == 204 || response.statusCode == 404) {
        Fluttertoast.showToast(
            msg: "Area  not found", toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(msg: _something, toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((ex, stack) {
      print("exception iss" + ex.toString() + stack.toString());
      Fluttertoast.showToast(
          msg: ex.toString(), toastLength: Toast.LENGTH_SHORT);
    }).timeout(Duration(seconds: _secs), onTimeout: () {
      Fluttertoast.showToast(
          msg: _timeoutString, toastLength: Toast.LENGTH_SHORT);
    });
    return areas;
  }

  static Future<dynamic> editShop({
    String customerCode,
    String imageUrl,
    String lat,
    String long,
    String address,
    String customerName,
    String customerName2,
    String customerPhoneNo,
    String CustomerPhoneNo2,
    String shopname,
    String partyCategory,
    String city,
    String area,
  }) {
    String url = directory +
        'posteditshop?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass&pin_cust_code=$customerCode&pin_shopname=${shopname}&pin_address=$address&pin_partycategory=$partyCategory&'
            'pin_image_url=${imageUrl}&pin_city=${city ?? ''}&pin_mobile=${customerPhoneNo}&pin_phone1=${customerPhoneNo}&pin_phone2=$CustomerPhoneNo2&pin_ntn=1'
            '&pin_person1=$customerName&pin_person2=$customerName2&pin_longitude=$long&pin_latitude=$lat&po_cust_code&pin_area=${area ?? ''}';
    print("edit customer url is: " + url);
    print("edit area url is: " + area);
    try {
      var response = http.post(Uri.parse(url), body: null);
      return response;
    } catch (e) {
      print("exception in edit shop api is" + e.toString());
    }
  }

  static Future<dynamic> getWalletStatus() async {
    var url = Uri.parse(directory +
        'getwalletstatus?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$phonepass');
    print("url is: " + url.toString());
    final response = await http.get(url);
    return response;
  }
  static Future<dynamic> sendTextMultiple(
      List<String> receivers, String msgData) async {
    String url =
        'https://jsims.com.pk/OnPointSMS.aspx?key=$smsApiKey&sender=SKR';
    url += '&receiver=';
    for (int i = 0; i < receivers.length; i++) {
      if (i != 0) {
        url += ',' + receivers[i].toString();
      } else {
        url += receivers[i].toString();
      }
    }
    url += '&msgdata=$msgData';
    //url += '&camp=camp1';
    print(url);
    var response = await http.post(Uri.parse(url));
    print(response.statusCode.toString());
    return response;
  }
}
