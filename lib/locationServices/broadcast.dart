import 'package:background_locator/background_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

class LocationBroadcast{
  static DateFormat logDateFormatter = new DateFormat('dd-MM-yyyy');
  static DateFormat timeFormatter = new DateFormat('HH:mm');

  static broadcastLocation(double latitude, double longitude, String userCellNumber, String userName)async{
    var userLatLng = Coordinates(latitude, longitude);
    var date = DateTime.now().millisecondsSinceEpoch;
    print(logDateFormatter.format(DateTime.fromMillisecondsSinceEpoch(date)));
    Map<String, dynamic> locationUpdate = {};
    locationUpdate['latitude'] = userLatLng.latitude;
    locationUpdate['longitude'] = userLatLng.longitude;
    locationUpdate['Name'] = userName;
    FirebaseDatabase.instance
        .reference()
        .child('Salesmen')
        .child(userCellNumber)
        .child(logDateFormatter.format(DateTime.fromMillisecondsSinceEpoch(date)))
        .child(date.toString())
        .set(locationUpdate);
  }

  static stopBroadcast()async{
    await BackgroundLocator.unRegisterLocationUpdate();
  }

}