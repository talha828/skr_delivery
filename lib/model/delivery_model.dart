import 'package:flutter/material.dart';
class DeliveryModel extends NotificationListener{
  String orderNumber;
  String orderLine;
  String productCode;
  String productName;
  int quantity;
  double rate;
  double itemtotal;
  String stockQuantity;
  String subTotal;
  String creditLimit;
  TextEditingController itemcountController;
  DeliveryModel();
  DeliveryModel.getMainDetails(Map<String,dynamic> json){
    try{
      orderNumber=json['ORDER_NO'].toString();
      subTotal=json['SUB_TOTAL'].toString();
      creditLimit=json['CREDIT_LIMIT'].toString();
    }
    catch(e,stack){
      print("exception in delivery model getMainDetails is:"+e.toString()+''+stack.toString());
    }
  }
  DeliveryModel.fromJson(Map<String,dynamic> json){
    try{
      orderNumber=json['ORDER_NO'].toString();
      orderLine=json['LINE'].toString();
      productCode=json['PROD_CODE'];
      productName=json['PRODUCT'];
      quantity=json['QTY'];
      rate=json['RATE'].toDouble();
      itemtotal=json['RATE'].toDouble();
      stockQuantity=json['STOCKQTY'].toString();
      itemcountController=new TextEditingController(text: json['QTY'].toString());
    }
    catch(e,stack){
      print("exception in delivery model is:"+e.toString()+''+stack.toString());
    }
  }

}