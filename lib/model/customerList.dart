import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:skr_delivery/model/box_model.dart';
import 'package:skr_delivery/model/delivery_model.dart';
import 'package:skr_delivery/model/product_model.dart';
import 'customerModel.dart';
import 'dart:math' show cos, sqrt, asin;

class CustomerList extends ChangeNotifier{
  //loader
  bool loading =false;
  //customer list
  List<CustomerModel>customerData=[];
  List<CustomerModel>dues=[];
  List<CustomerModel>assign=[];
  // main product list or category
  List<ProductModel>product=[];
  List<ProductModel>searchProduct=[];
  // slider image
  List<Widget> imageContainer=[];
  CustomerModel singleCustomer=CustomerModel();
  //delivery list
  List<DeliveryModel> delivery =[];
  List<BoxModel>boxDelivery=[];
  List<DeliveryModel>fulldeliveryDetails=[];
  List initialCount=[];
  // store json response
  Map<String,dynamic> response1={};
  Map<String,dynamic> response2={};
  // product list
  List<List<ProductModel>> pp=[];

  String address="Searching...";
  void getAllCustomer(List<CustomerModel> value){
    customerData.clear();
    customerData.addAll(value);
    notifyListeners();
  }
  void updateAddress(String value){
    address=value;
    notifyListeners();
  }
  void getDues(List<CustomerModel> value){
    dues.clear();
    for (var i in value){
      if(i.shopAssigned=="Yes"){
        if(double.parse(i.dues)>0.00){
          dues.add(i);
        }
      }
    }
    notifyListeners();
  }
  void sliderPicture(List<Widget> value){
    imageContainer.addAll(value);
    notifyListeners();
  }
  void getAssignShop(List<CustomerModel> value){
    assign.clear();
        assign.addAll(value);
    notifyListeners();
  }
  void addProduct(List<ProductModel> value){
    product.addAll(value);
    notifyListeners();
  }
  void myCustomer(CustomerModel value){
    singleCustomer=value;
    notifyListeners();
  }
  void clearList(){
    customerData.clear();
    dues.clear();
    assign.clear();
    notifyListeners();
  }
  void clearSliderImage(){
    imageContainer.clear();
  }
  void clearProductList(){
    product.clear();
  }
  void clearProductSearchList(){
    searchProduct.clear();
  }
  void addSearchProduct(List<ProductModel> value){
    searchProduct.addAll(value);
  }
  void addDelivery(List<DeliveryModel> value){
    delivery.addAll(value);
  }
  void addBoxDelivery(List<BoxModel> value){
    boxDelivery.addAll(value);
  }
  void addFullDeliveryDetails(List<DeliveryModel> value){
    fulldeliveryDetails.addAll(value);
  }
  void addInitialCount(List value){
    initialCount.addAll(value);
  }
  void addNewCustomer(CustomerModel value){
    customerData.insert(0,value);
    assign.insert(0,value);
  }
  void setLoading(bool value){
    loading=value;
  }
  void storeResponse1(Map<String,dynamic>value){
    response1.addAll(value);
  }
  void storeResponse2(Map<String,dynamic>value){
    response2.addAll(value);
  }
  void addProductItem(List<List<ProductModel>> value){
    pp.addAll(value);
  }
  void updateList1(Coordinates userLocation ){
    List<CustomerModel>customer=[];
    for (var item in response1["results"]){
      var dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLocation.latitude,userLocation.longitude);
      customer.add(CustomerModel.fromModel(item,distance: dist));
    }
    customer.sort((a,b)=>a.distance.compareTo(b.distance));
    getAssignShop(customer);
    notifyListeners();
  }
  void updateList2(Coordinates userLocation ){
    List<CustomerModel>customer=[];
    for (var item in response2["results"]){
      var dist=calculateDistance(double.parse(item["LATITUDE"].toString()=="null"?1.toString():item["LATITUDE"].toString()), double.parse(item["LONGITUDE"].toString()=="null"?1.toString():item["LONGITUDE"].toString()),userLocation.latitude,userLocation.longitude);
      customer.add(CustomerModel.fromModel(item,distance: dist));
    }
    customer.sort((a,b)=>a.distance.compareTo(b.distance));
    getAllCustomer(customer);
    notifyListeners();
  }
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}