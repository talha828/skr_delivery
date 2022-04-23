import 'package:flutter/cupertino.dart';
import 'package:skr_delivery/model/product_model.dart';


class RetrunCartModel with ChangeNotifier {
  List<ReturnCartItem> returncartItemName;
  RetrunCartModel({this.returncartItemName = null, notifyListeners()});
  RetrunCartModel.fromJson(Map<String, dynamic> json) {
    returncartItemName = json[''];
  }
  retruncreateCart() {
    List<ReturnCartItem> temp = [];
    for (int i = 0; i < 1; i++) {
      temp.add(ReturnCartItem(
          productName: ProductModel(),
          itemCount: 0,
          priceModel:null,
          itemPrice: 0,
          subTotalPrice: 0,
          itemcountController: TextEditingController(text: '0')));
    }
    returncartItemName = temp;
    notifyListeners();
  }

  retrunupdateCart() {
    List<ReturnCartItem> temp = [];
    temp.addAll(returncartItemName);
    print(returncartItemName.length.toString());
    for (int i = returncartItemName.length - 1; i >= 0; i--) {
      if (returncartItemName[i].itemCount < 1) {
        temp.removeAt(i);
      } else {
        print('abcd  ' + temp[i].itemCount.toString());
      }
    }
    returncartItemName.clear();
    print(temp.length.toString());
    returncartItemName.addAll(temp);
    notifyListeners();
  }


  retrunclearCart() {
    returncartItemName.clear();
    notifyListeners();
  }
}

class ReturnCartItem with ChangeNotifier {
  ProductModel productName;
  int itemCount;
  int itemPrice;
  int subTotalPrice;
  List<productPriceModel> priceModel;
  TextEditingController itemcountController;

  ReturnCartItem(
      {this.productName = null,
        this.itemCount = 1,
        this.itemPrice = null,
        this.priceModel=null,
        this.subTotalPrice = null,
        this.itemcountController,
        notifyListeners()});



  ReturnCartItem.fromModel(ReturnCartItem item){
    productName=ProductModel(
        price: item.productName.price,
        name: item.productName.name,
        productCode: item.productName.productCode
    );
    priceModel=item.priceModel;
    itemCount=item.itemCount;
    itemPrice=item.itemPrice;
    subTotalPrice=item.subTotalPrice;
    itemcountController=new TextEditingController();

  }
}


