class Area {
  String areacityCode;
  String areaCode;
  String areacityName;
  String areaName;
  String areacityNickName;
  String areacityCountryName;
  String areacityDialCode;
  Area(
      {this.areacityCode,
      this.areaCode,
      this.areaName,
        this.areacityName,
        this.areacityNickName,
        this.areacityCountryName,
        this.areacityDialCode});

  Area.fromJson(Map<String, dynamic> json) {
    try {

      areaCode = json['AREA_CODE'].toString();
      areacityCode = json['CITY_CODE'].toString();
      areaName = json['AREA_NAME'];
      areacityName = json['CITY'];
      areacityNickName = json['NICK_NAME'];
      areacityCountryName = json['COUNTRY'];
      areacityDialCode = json['DIAL_CODE'];
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() {
    return areaCode;
  }
}
