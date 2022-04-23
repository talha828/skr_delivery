import 'package:flutter/material.dart';

class BoxModel{
  String trNumber;
  String transDate;
  String custCode;
  String customer;
  String empNo;
  String totalAmount;
  String delivered;
  List<BoxOrder> orders = [];

  BoxModel.fromJson(Map<String, dynamic> json){
    trNumber = json['TR'].toString();
    transDate = json['TRANS_DATE'];
    custCode = json['CUST_CODE'];
    customer = json['CUSTOMER'];
    empNo = json['EMPNO'];
    totalAmount = json['TOTAL_AMOUNT'].toString();
    delivered = json['DELIVERED'];
    for(var item in json['ORDERS']){
      orders.add(BoxOrder.fromJson(item));
    }
  }
}

class BoxOrder{
  String orderNumber;
  String orderDate;
  String prodCode;
  String product;
  String orderQty;
  String transferQty;
  String rate;
  String amount;

  BoxOrder.fromJson(Map<String, dynamic> json){
    orderNumber = json['ORDERNO'].toString();
    orderDate = json['ORDERDATE'];
    prodCode = json['PROD_CODE'];
    product = json['PRODUCT'];
    orderQty = json['ORDERQTY'].toString();
    transferQty = json['TRANSSFERQTY'].toString();
    rate = json['RATE'].toString();
    amount = json['AMOUNT'].toString();
  }
}