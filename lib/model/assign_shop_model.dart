
class AssignShopModel {
  String cATEGORY;
  String cUSTCODE;
  String cUSTOMER;
  String aDDRESS;
  String pHONE1;
  String oWNER;
  double lATITUDE;
  double lONGITUDE;
  int lASTVISTDAYS;
  int lASTTRANSDAYS;
  double dUES;
  double oUTSTANDING;
  String eMPNO;
  String sALESMAN;
  String aREACODE;
  String aREANAME;
  String sHOPASSIGNED;
  String aPPALLOWED;
  List<DATA> dATA;

  AssignShopModel(
      {this.cATEGORY,
        this.cUSTCODE,
        this.cUSTOMER,
        this.aDDRESS,
        this.pHONE1,
        this.oWNER,
        this.lATITUDE,
        this.lONGITUDE,
        this.lASTVISTDAYS,
        this.lASTTRANSDAYS,
        this.dUES,
        this.oUTSTANDING,
        this.eMPNO,
        this.sALESMAN,
        this.aREACODE,
        this.aREANAME,
        this.sHOPASSIGNED,
        this.aPPALLOWED,
        this.dATA});

  AssignShopModel.fromJson(Map<String, dynamic> json) {
    cATEGORY = json['CATEGORY'];
    cUSTCODE = json['CUST_CODE'];
    cUSTOMER = json['CUSTOMER'];
    aDDRESS = json['ADDRESS'];
    pHONE1 = json['PHONE1'];
    oWNER = json['OWNER'];
    lATITUDE = json['LATITUDE'];
    lONGITUDE = json['LONGITUDE'];
    lASTVISTDAYS = json['LAST_VIST_DAYS'];
    lASTTRANSDAYS = json['LAST_TRANS_DAYS'];
    dUES = json['DUES'];
    oUTSTANDING = json['OUTSTANDING'];
    eMPNO = json['EMPNO'];
    sALESMAN = json['SALESMAN'];
    aREACODE = json['AREA_CODE'];
    aREANAME = json['AREANAME'];
    sHOPASSIGNED = json['SHOPASSIGNED'];
    aPPALLOWED = json['APP_ALLOWED'];
    if (json['DATA'] != null) {
      dATA = <DATA>[];
      json['DATA'].forEach((v) {
        dATA.add(new DATA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CATEGORY'] = this.cATEGORY;
    data['CUST_CODE'] = this.cUSTCODE;
    data['CUSTOMER'] = this.cUSTOMER;
    data['ADDRESS'] = this.aDDRESS;
    data['PHONE1'] = this.pHONE1;
    data['OWNER'] = this.oWNER;
    data['LATITUDE'] = this.lATITUDE;
    data['LONGITUDE'] = this.lONGITUDE;
    data['LAST_VIST_DAYS'] = this.lASTVISTDAYS;
    data['LAST_TRANS_DAYS'] = this.lASTTRANSDAYS;
    data['DUES'] = this.dUES;
    data['OUTSTANDING'] = this.oUTSTANDING;
    data['EMPNO'] = this.eMPNO;
    data['SALESMAN'] = this.sALESMAN;
    data['AREA_CODE'] = this.aREACODE;
    data['AREANAME'] = this.aREANAME;
    data['SHOPASSIGNED'] = this.sHOPASSIGNED;
    data['APP_ALLOWED'] = this.aPPALLOWED;
    if (this.dATA != null) {
      data['DATA'] = this.dATA.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DATA {
  String kEY;
  String vALUE;

  DATA({this.kEY, this.vALUE});

  DATA.fromJson(Map<String, dynamic> json) {
    kEY = json['KEY'];
    vALUE = json['VALUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['KEY'] = this.kEY;
    data['VALUE'] = this.vALUE;
    return data;
  }
}
