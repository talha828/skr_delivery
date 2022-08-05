import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/user_model.dart';
import 'package:skr_delivery/screens/main_screen/main_screen.dart';

import '../../widget/constant.dart';

class LoginSuccessful extends StatelessWidget {
  final password;
  LoginSuccessful({this.password});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: themeColor1,
        onPressed: ()async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userCellNumber = Provider.of<UserModel>(context, listen: false).phoneNumber;
          var  userName = Provider.of<UserModel>(context, listen: false).userName;
          prefs.setString('phoneno', userCellNumber.toString());
          prefs.setString('name',userName.toString());
          prefs.setString('password',password.toString());
          phoneNumber=prefs.getString('phoneno');
          myPassword=prefs.getString('password');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(check:true)));
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Login Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward_outlined,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(  
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/logo.png",
                      scale: 3,
                    ),
                  )),
              Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/phone.png",
                      scale: 1.7,
                    ),
                  )),
              Text(
                "Successfully Verified",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "you have successfully verified",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                "your account",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
