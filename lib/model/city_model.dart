class City {
  String cityCode;
  String cityName;
  String cityNickName;
  String cityCountryName;
  String cityDialCode;
  City(
      {this.cityCode,
      this.cityName,
      this.cityNickName,
      this.cityCountryName,
      this.cityDialCode});
  City.fromJson(Map<String, dynamic> json) {
    try {
      cityCode = json['CITY_CODE'].toString() ?? 'NULL';
      cityName = json['CITY'];
      cityNickName = json['NICK_NAME'];
      cityCountryName = json['COUNTRY'];
      cityDialCode = json['DIAL_CODE'];
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  String toString() {
    return cityCode;
  }
}
