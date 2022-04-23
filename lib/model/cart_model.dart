import 'package:flutter/cupertino.dart';
import 'package:skr_delivery/model/product_model.dart';


class CartModel with ChangeNotifier {
  List<CartItem> cartItemName = [];
  double subTotal;
  CartModel();
  CartModel.fromJson(Map<String, dynamic> json) {
    cartItemName = json[''];
  }

  /*addToCart(CartItem item){
    List<CartItem> temp = [];
    temp.add(item);

    if(cartItemName.contains(temp[0])){
      print("already added");
    }else{
      print("new");
    }

    cartItemName = temp;
    notifyListeners();
  }*/

  updateSubTotal(){
    subTotal = 0;
    double tempPrice;
    for(var item in cartItemName){
      tempPrice = double.parse(item.priceModel.last.price.toStringAsFixed(2));
      for(var item2 in item.priceModel){
        if(item2.min<=item.itemCount && item2.max>=item.itemCount){
          tempPrice = double.parse(item2.price.toStringAsFixed(2));
        }
      }
      subTotal += (item.itemCount * tempPrice);
    }
  }

  addToCart({CartItem item,int itemC}){
    bool hasItem=false;
    if(cartItemName.isEmpty){
      item.itemPrice = calculatePrice(quantity: itemC,productDetails: item.productName);
      cartItemName.add(item);
    }
    else{
      for(var item2 in cartItemName){
        if(item2.productName.productCode == item.productName.productCode){
          item2.itemCount =itemC;
          item2.itemPrice = calculatePrice(quantity: itemC,productDetails: item2.productName);
          //item2.itemTotal = itemC*calculatePrice(quantity: itemC,productDetils: productData);
          hasItem=true;
          break;
        }

      }
      if(!hasItem){
        item.itemPrice = calculatePrice(quantity: itemC,productDetails: item.productName);
        cartItemName.add(item);
      }
    }
    updateSubTotal();
    notifyListeners();
  }

  double calculatePrice({int quantity,ProductModel productDetails}){
    double dynamicprice;
    for(var item in productDetails.productPrice){
      if(item.min<=quantity && item.max>=quantity){
        dynamicprice=double.parse(item.price.toStringAsFixed(2));
      }
    }
    return dynamicprice;
  }

  createCart() {
    List<CartItem> temp = [];
    for (int i = 0; i < 1; i++) {
      temp.add(CartItem(
          productName: ProductModel(),
          itemCount: 0,
          priceModel:null,
          itemPrice: 0,
          subTotalPrice: 0,
      itemcountController: TextEditingController(text: '0')));
    }
    cartItemName = temp;
    notifyListeners();
  }

  updateCart() {
    List<CartItem> temp = [];
    temp.addAll(cartItemName);
    print(cartItemName.length.toString());
    for (int i = cartItemName.length - 1; i >= 0; i--) {
      if (cartItemName[i].itemCount < 1) {
        temp.removeAt(i);
      } else {
        print('@@@@  ' + temp[i].itemCount.toString());
      }
    }
    cartItemName.clear();
    print(temp.length.toString());
    cartItemName.addAll(temp);
    updateSubTotal();
    notifyListeners();
  }

  clearCart() {
    cartItemName.clear();
    updateCart();
    notifyListeners();
  }
}

class CartItem with ChangeNotifier {
  ProductModel productName;
  int itemCount;
  double itemPrice;
  double subTotalPrice;
  List<productPriceModel> priceModel;
  TextEditingController itemcountController;

  CartItem(
      {this.productName = null,
      this.itemCount = 1,
        this.priceModel=null,
      this.itemPrice = null,
      this.subTotalPrice = null,
        this.itemcountController,
      notifyListeners()});


  
  CartItem.fromModel(CartItem item){
    productName=ProductModel(
      price: item.productName.price,
      name: item.productName.name,
      productCode: item.productName.productCode,

    );
    priceModel=item.priceModel;
    itemCount=item.itemCount;
    itemPrice=item.itemPrice;
    subTotalPrice=item.subTotalPrice;
    itemcountController=new TextEditingController();

  }
}


