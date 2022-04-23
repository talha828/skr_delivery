

import 'package:background_locator/background_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skr_delivery/model/user_model.dart';

class LocationBroadcast{
  String userName;
  static DateFormat logDateFormatter = new DateFormat('dd-MM-yyyy');
  static DateFormat timeFormatter = new DateFormat('HH:mm');

  static broadcastLocation(double latitude, double longitude)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userLatLng = Coordinates(latitude, longitude);
    var date = DateTime.now().millisecondsSinceEpoch;
    print(logDateFormatter.format(DateTime.fromMillisecondsSinceEpoch(date)));
    Map<String, dynamic> locationUpdate = {};
    locationUpdate['latitude'] = userLatLng.latitude;
    locationUpdate['longitude'] = userLatLng.longitude;
    FirebaseDatabase.instance
        .reference()
        .child('Delivery')
        .child(prefs.getString('name'))
        .child(logDateFormatter.format(DateTime.fromMillisecondsSinceEpoch(date)))
        .child(date.toString())
        .set(locationUpdate);
  }

  static stopBroadcast()async{
    await BackgroundLocator.unRegisterLocationUpdate();
  }
}