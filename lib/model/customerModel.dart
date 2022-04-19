import 'package:flutter/cupertino.dart';

class CustomerModel extends ChangeNotifier {
  String customerCode;
  String customerShopName;
  String customerName;
  String customerEmail;
  String customerCnic;
  String customerCategory;
  String customerCnicExpiry;
  var customerLatitude;
  var customerLongitude;
  String customerContactPersonName;
  String customerContactPersonName2;
  String customerContactNumber;
  String customerContactNumber2;
  String customerAddress;
  String customerCreditLimit;
  String customerImage;
  String customerCountryName;
  String customerCityCode;
  String customerCityName;
  String customerAreaCode;
  String customerAreaName;
  String customerUCCode;
  String customerUCName;
  String customerMarketCode;
  String customerMarketName;
  String customerCatCode;
  String customerTermCode;
  String customerPayTerm;
  String customerNTN;
  String customerPartyCategory;
  String lastVisitDay;
  String lastTransDay;
  String dues;
  String outStanding;
  String editable;
  String shopAssigned;
  List<customerInfo> customerinfo=[];
  double distance;


  CustomerModel(
      {this.customerCode,
        this.customerShopName,
        this.customerName,
        this.customerLatitude,
        this.customerLongitude,
        this.customerCreditLimit,
        this.customerAddress,
        this.customerImage,
        this.customerContactPersonName,
        this.customerContactNumber,
        this.customerCountryName,
        this.customerCityCode,
        this.customerCityName,
        this.customerAreaCode,
        this.customerAreaName,
        this.customerUCCode,
        this.customerUCName,
        this.customerMarketCode,
        this.customerMarketName,
        this.customerContactPersonName2,
        this.customerContactNumber2,
        this.customerEmail,
        this.customerCnic,
        this.customerCnicExpiry,
        this.customerCatCode,
        this.customerNTN,
        this.customerPartyCategory,
        this.customerCategory,
        this.customerPayTerm,
        this.customerTermCode,
        this.lastVisitDay,
        this.lastTransDay,
        this.dues,
        this.outStanding,
        this.customerinfo,
        this.editable,
        this.shopAssigned,
        this.distance
      });

  CustomerModel.fromModel(Map<String, dynamic> json, {double distance}) {
    try {
      customerCode = json['CUST_CODE'];
      customerShopName = json['CUSTOMER'];
      customerName = json['NICK_NAME'];
      customerLatitude = json['LATITUDE']??null;
      customerLongitude = json['LONGITUDE']??null;
      customerAddress = json['ADDRESS'] ?? 'Not Found';
      customerContactPersonName = json['OWNER'] ?? '-';
      customerContactNumber = json['CELL'].toString() ?? '-';
      customerCreditLimit = json['CREDIT_LIMIT'].toString();
      customerImage = json['IMAGEURL'];
      customerCountryName = json["COUNTRY"];
      customerCityCode = json["CITY_CODE"].toString();
      customerCityName = json["CITY"];
      customerAreaCode = json["AREA_CODE"];
      customerAreaName = json["AREA_NAME"];
      customerUCCode = json["UC_CODE"];
      customerUCName = json["US_NAME"];
      customerMarketCode = json["MARKET_CODE"];
      customerMarketName = json["MARKET_NAME"];
      customerContactPersonName2 = json['CONTACT_PERSON2'];
      customerContactNumber2 = json['PHONE2'];
      customerEmail = json['EMAIL'];
      customerCnic = json['CNIC'].toString();
      customerCnicExpiry = json['CNIC_EXPIRY'];
      customerCatCode = json['CAT_CD'];
      customerNTN = json['NTN'];
      customerPartyCategory = json['PARTY_CATEGORY'];
      customerPayTerm = json['PAYMENT_TERM'];
      customerTermCode = json['TERM_CODE'];
      lastVisitDay=json['LAST_VIST_DAYS'].toString();
      lastTransDay=json['LAST_TRANS_DAYS'].toString();
      customerCategory=json['CATEGORY']?? '-';
      dues=json['DUES'].toString();
      outStanding=json['OUTSTANDING'].toString();
      editable = json['EDITABLE'].toString();
      shopAssigned = json['SHOPASSIGNED'].toString();
      this.distance = distance;
      if(json['DATA'] != null){
        for(var item in json['DATA']){
          if(item != null){
            customerinfo.add(customerInfo.fromJson(item));
          }
        }
      }
    } catch (e, stack) {
      print("customer model exception is" + e.toString() + stack.toString());
    }
  }
}
class customerInfo{
  String key;
  String value;
  customerInfo();
  customerInfo.fromJson(Map<String,dynamic> json){
    key=json['KEY'];
    value=json['VALUE'];
  }
}
