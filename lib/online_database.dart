import 'online_auth.dart';
import 'package:http/http.dart' as http;
//TODO phone number;
String phoneNumber="+921234567890";
String password="123456";

class OnlineDataBase{
  static Future<dynamic> getAllCustomer() async {

    String url=directory+
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+92&pin_password=123&pin_datatype=INFO';
    print("url is: "+url);
    //TODO set phone number and password
    final response = await http.get(
        Uri.parse(url));
    return response;
  }
  static Future<dynamic> getImage() async {

    String url=directory+
        'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=+92&pin_password=123';
    print("url is: "+url);
    //TODO set phone number and password
    final response = await http.get(
        Uri.parse(url));
    return response;
  }
  static Future<dynamic> getTranactionDetails({String customerCode}) async {
    var url =Uri.parse(directory+ 'getcustomers?pin_cmp=20&pin_kp=A&pin_keyword1=X09&pin_keyword2=912&pin_userid=$phoneNumber&pin_password=$password&pin_cust_code=$customerCode&pin_datatype=CRLB');
    print('getTranactionDetails url is: '+url.toString());
    final response = await http.get(url);
    return response;
  }
}