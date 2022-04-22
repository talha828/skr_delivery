import 'package:flutter/cupertino.dart';
class UserModel extends ChangeNotifier{
  String userID;
  String userName;
  String email;
  String phoneNumber;
  String userDesignation;
  String userEmpolyeeNumber;
  String usercashReceive;
  String usercashLimit;
  UserModel();
  userSignIn(Map<String,dynamic> json){
    try{
      userID=json['results'][0]["USERID"].toString();
      userName =json['results'][0]["USERNAME"];
      email  =json['results'][0]["EMAIL"];
      phoneNumber =json['results'][0]["CELL"];
      userDesignation =json['results'][0]["DESIG"];
      userEmpolyeeNumber =json['results'][0]["EMPNO"];
      notifyListeners();
    }
    catch(e){
      print('user model exception is'+e.toString());
    }
  }

  getWalletStatus(Map<String,dynamic> json){
    try{
      usercashReceive=json['results'][0]['CASH_RECEIVED'].toString();
      usercashLimit=json['results'][0]['CASH_LIMIT'].toString();
    }
    catch(e){
      print('exception in get wallet status is'+e.toString());
    }
  }
}