import 'package:flutter/cupertino.dart';

class ProductModel extends ChangeNotifier {
  String name;
  double price;
  String brand;
  String model;
  String productDescription;
  String outOfStock;
  String productCode;
  String productMainType;
  String productSubType;
  int quantity;
  String productmaintypeId;
  String productmaintypeName;
  List<ProductSubTypes> productsubtypeList = [];
  List<productPriceModel> productPrice = [];
  String imageUrl;

  ProductModel(
      {this.name = null,
      this.price = 0,
      this.productDescription = null,
      this.productCode = null,
      this.productPrice,
      this.imageUrl,
        this.outOfStock,
        this.brand, this.model
      //List<productPriceModel> productprice = null
      });

  @override
  String toString() {
    return name;
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      name = json["PRODUCT"];
      //price=json["SELLING_PRICE"]??0;
      productCode = json['PROD_CODE'];
      productMainType = json['MAINTYPE'];
      productSubType = json['SUBTYPE'];
      brand = json['BRAND'];
      model = json['MODEL'];
      imageUrl =json['IMAGE_URL'] == "no image" ? null : json['IMAGE_URL'];
          /* "https://suqexpress.com/assets/images/product/1644320668_5659_download.jpg";*/  //== "no image" ? null : json['IMAGE_URL'];
      outOfStock = json['OUTOFSTOCK'] ?? 'N';
      productDescription =
          json['DESCRIPTION'] == null ? null : json['DESCRIPTION'].toString();
      for (var item in json['PRICE']) {
        productPrice.add(productPriceModel.fromJson(item));
      }
    } catch (e) {
      print("ProductModel.fromModel exception is:" + e.toString());
    }
  }

  ProductModel.getProductMainCategory(Map<String, dynamic> json) {
    try {
      productmaintypeId = json['MAINTYPEID'];
      productmaintypeName = json['MAINTYPENAME'];
      for (var item in json['SUBTYPES']) {
        productsubtypeList.add(ProductSubTypes.fromJson(item));
      }
    } catch (e) {
      print("ProductModel.getProductMainCategory exception is:" + e.toString());
    }
  }

  ProductModel.getStock(Map<String, dynamic> json) {
    try {
      productCode = json['PROD_CODE'];
      name = json["PRODUCT"];
      quantity = json["QTY"] ?? 0;
    } catch (e) {
      print("ProductModel.getStock exception is:" + e.toString());
    }
  }
}

class productPriceModel {
  int min;
  int max;
  var price;
  productPriceModel({this.price = 0, this.max = 0, this.min = 0});

  productPriceModel.fromJson(Map<String, dynamic> json) {
    try {
      min = json['MIN'];
      max = json['MAX'];
      price = json['SELLING_PRICE'];
    } catch (e) {
      print("error in product pricr api is: " + e.toString());
    }
  }
}

class ProductSubTypes {
  String productsubtypeId;
  String productsubtypeName;

  ProductSubTypes();

  ProductSubTypes.fromJson(Map<String, dynamic> json) {
    try {
      productsubtypeId = json['SUBTYPDID'];
      productsubtypeName = json['SUBTYPENAME'];
    } catch (e) {
      print('Exception in ProductSubTypes.fromJson is ' + e.toString());
    }
  }
}
