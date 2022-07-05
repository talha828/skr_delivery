import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skr_delivery/ApiCode/online_database.dart';
import 'package:skr_delivery/model/customerModel.dart';
import 'package:skr_delivery/model/product_model.dart';
import 'package:skr_delivery/model/retrun_cart_model.dart';
import 'package:skr_delivery/screens/RetrunScreen/return_sucessfully.dart';
import 'package:skr_delivery/screens/loginScreen/passwordScreen/loader.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';


class ReturnScreen extends StatefulWidget {
  List<ReturnCartItem> returncartData=[];
  CustomerModel shopDetails;
  double lat,long;
  List<ProductModel> product=[];
  //var shopDetails;
  ReturnScreen({this.returncartData,this.shopDetails,this.lat,this.long,this.product});
  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  var f = NumberFormat("###,###.0#", "en_US");

  bool isLoading=false;
  bool isLoading2=false;
  List<int> cartEmptyIndex=[];

  //List<CartModel> cartData=[];

  List<ProductModel> sel_product= List<ProductModel>();

  @override
  void initState() {
    super.initState();
    if(widget.returncartData[0].productName.name != null){
      for(int i=0;i<widget.returncartData.length;i++){
        sel_product.add(widget.returncartData[i].productName);
      }
    }
  }
  bool checkOrderSummary=false;
  double sizedboxvalue=0.02;
  int count=0;
  changeScreen(){
    setState(() {
      checkOrderSummary=false;
    });
  }
  popScreen(){
    Navigator.pop(context);


  }

  @override
  Widget build(BuildContext context) {
    //CartModel cartData=CartModel(cartItemName:null);
    var cartData=Provider.of<RetrunCartModel>(context,listen: true);
    int subtotal=0;
    int quantity=0;
    for(int i=0;i<cartData.returncartItemName.length;i++){
      quantity+=cartData.returncartItemName[i].itemCount;

      try{
        subtotal+=(cartData.returncartItemName[i].itemCount)*(cartData.returncartItemName[i].itemPrice);
        //subtotal+=(cartData.returncartItemName[i].itemCount)*(cartData.returncartItemName[i].productName.price.toInt());
      }
      catch(e){print("exception is"+e.toString());}
    }
    var media=MediaQuery.of(context).size;
    double height=media.height;
    double width=media.width;
    return WillPopScope(
      onWillPop: (){
        checkOrderSummary?
        changeScreen() :
        popScreen();


      },
      //Provider.of<CartModel>(context,listen: false).updateCart();
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: themeColor1,
              title: VariableText(
                text: 'Return Screen',
                fontsize: 18,
                fontcolor: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //api integrated
                    customShopDetailsContainer(shopname:
                    widget.shopDetails.customerShopName.toString(),address:
                    widget.shopDetails.customerCode.toString(),
                        height: height,width: width,imageurl: widget.shopDetails.customerImage),

                    SizedBox(height:height*sizedboxvalue,),
                    checkOrderSummary?orderSummaryBlock(cartData,height,width):orderDetailsBlock(cartData,height,width),
                  ]

              ),
            ),
            floatingActionButton:checkOrderSummary?Container():FloatingActionButton(
              onPressed: (){
                if(cartData.returncartItemName[cartData.returncartItemName.length-1].itemCount == 0){
                  Fluttertoast.showToast(
                      msg: "Please select product",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }else{
                  cartData.returncartItemName.add(ReturnCartItem(productName: ProductModel(), itemCount: 0, itemPrice: 0, subTotalPrice: 0, itemcountController: TextEditingController(text: '0')));
                  setState(() {


                  });
                }
              },
              elevation: 1,
              child: Image.asset('assets/icons/pluss.png',
                scale: 3.5,
                color:themeColor2,),
              backgroundColor: themeColor1,),
            bottomNavigationBar: BottomAppBar(
              child:     checkOrderSummary?InkWell(
                onTap: (){
                  postReturnOrder(cartData);
                  Fluttertoast.showToast(
                      msg: "Successfully Return",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Container(
                  color: themeColor2,
                  child: Padding(
                    padding:  EdgeInsets.all(15),
                    child: Container(
                      height: height*0.06,
                      decoration: BoxDecoration(
                        color: themeColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: VariableText(
                            text: 'RETURN NOW',
                            weight: FontWeight.w700,
                            fontsize: 15,
                            fontcolor: themeColor2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ): InkWell(
                onTap: (){

                  if(checkOrderSummary==false){
                    setState(() {
                      Provider.of<RetrunCartModel>(context,listen: false).retrunupdateCart();
                      temp.clear();
                      checkOrderSummary=true;
                    });}
                  else{
                    setState(() {
                      checkOrderSummary=false;
                    });
                  }

                },
                child: Container(
                  color: themeColor2,
                  child: Padding(
                    padding:  EdgeInsets.all(15),
                    child: Container(
                      height: height*0.06,
                      decoration: BoxDecoration(
                        color: themeColor1,
                        borderRadius: BorderRadius.circular(4),

                      ),

                      child:   Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              //height: height*0.04,
                              decoration: BoxDecoration(
                                  color: themeColor1,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: themeColor2)

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: VariableText(
                                  // text: quantity.toString(),
                                  text: cartData.returncartItemName.length.toString(),
                                  weight: FontWeight.w500,
                                  fontsize: 13,
                                  fontcolor: themeColor2,
                                ),
                              ),),
                            Spacer(),
                            VariableText(
                              text: 'Check Return Summary',
                              weight: FontWeight.w500,
                              fontsize: 13,
                              fontcolor: themeColor2,
                            ),
                            Spacer(),

                            VariableText(
                              text: 'Rs.${f.format(double.parse(subtotal.toString()))}',

                              weight: FontWeight.w700,
                              fontsize: 13,
                              fontcolor: themeColor2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          isLoading2 ? Positioned.fill(child: loader()) : Container(),
        ],
      ),
    );
  }



  Widget orderDetailsBlock(RetrunCartModel cartData,double height,double width,){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15),
              child: VariableText(
                text: 'ITEMS',
                fontsize:12,fontcolor: textcolorgrey,
                weight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height:height*sizedboxvalue,),
        isLoading ? Container(
            height: height*0.30,
            width: width,
            child: loader()) :
        cartData.returncartItemName.length<1?Container(
          height: height*0.35,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VariableText(text: "No item Added",)
            ],
          ),
        ):
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cartData.returncartItemName.length,
            physics: ScrollPhysics(),
            //itemCount: product.length,
            itemBuilder: (BuildContext context,int index){
              for(int i=0;i<cartData.returncartItemName.length;i++){
                sel_product.add(null);
              }
              return  Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      // height: height*0.09,
                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 15/2),
                        child: Row(
                          children: [
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap:(){
                                  if( cartData.returncartItemName.length<=1){
                                    Fluttertoast.showToast(
                                        msg: "You can't clear cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  else{
                                    cartData.returncartItemName.removeAt(index);
                                    sel_product.removeAt(index);
                                    setState(() {
                                    });}

                                },
                                child: Container(
                                  child: Image.asset('assets/icons/delete.png',scale: 3.5,color: themeColor1,),
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 4,
                              child:
                              Container(
                                // height: height*0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: themeColor1.withOpacity(0.6)),
                                  color: themeColor1.withOpacity(0.5),

                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){

                                          if(   sel_product[index]!=null){
                                            if( cartData.returncartItemName[index].itemCount>1){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount--;
                                                cartData.returncartItemName[index].itemcountController.text=cartData.returncartItemName[index].itemCount.toString();
                                                cartData.returncartItemName[index].itemPrice= calculatePrice(quantity: cartData.returncartItemName[index].itemCount,productDetils: sel_product[index])??0;
                                                // cartData.cartItemName[index].subTotalPrice= cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount;
                                                cartData.returncartItemName[index].subTotalPrice= cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount;
                                              });
                                            }}
                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Please select product",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            print("Please select product ");
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                          ),
                                          height: height*0.04,

                                          child: Image.asset('assets/icons/minus.png',scale: 2.5,color: themeColor1,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:3,
                                      child: Container(
                                        height: height*0.04,
                                        color: themeColor2,
                                        child: Center(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            controller:cartData.returncartItemName[index].itemcountController,

                                            decoration:InputDecoration(
                                              hintText:cartData.returncartItemName[index].itemCount.toString(),
                                              hintStyle: TextStyle(
                                                fontSize:13,color: themeColor1,
                                                fontWeight: FontWeight.w500,
                                                ),

                                              contentPadding: EdgeInsets.all(2),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,),

                                            ),
                                            readOnly:sel_product[index]==null?true:false,
                                            onChanged: (value){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount=int.parse(value, onError: (source) => 0);
                                                cartData.returncartItemName[index].itemPrice= calculatePrice(quantity: cartData.returncartItemName[index].itemCount,productDetils: sel_product[index])??0;
                                                cartData.returncartItemName[index].subTotalPrice=cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount??1;

                                              });

                                            },

                                            style: TextStyle(
                                              fontSize:13,color: themeColor1,
                                              fontWeight: FontWeight.w500,
                                              ),
                                          ),

                                          /* child: VariableText(
                                           text: cartData.cartItemName[index].itemCount.toString(),
                                            fontsize:13,fontcolor: themeColor1,
                                            weight: FontWeight.w500,
                                            fontFamily: fontMedium,
                                            max_lines: 1,
                                          ),*/
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
                                          print(sel_product[index]);

                                          if( sel_product[index]!=null){
                                            if(cartData.returncartItemName[index].itemCount>=0){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount++;
                                                cartData.returncartItemName[index].itemcountController.text=cartData.returncartItemName[index].itemCount.toString();
                                                cartData.returncartItemName[index].itemPrice= calculatePrice(quantity: cartData.returncartItemName[index].itemCount,productDetils: sel_product[index])??0;
                                                //cartData.cartItemName[index].subTotalPrice= cartData.cartItemName[index].itemPrice*cartData.cartItemName[index].itemCount;
                                                cartData.returncartItemName[index].subTotalPrice=cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount;
                                              });
                                              //  print("pricee is"+ cartData.cartItemName[index].subTotalPrice.toString());
                                            }}

                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Please select product",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }

                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),

                                          ),
                                          height: height*0.04,
                                          child: Image.asset('assets/icons/plus.png',scale: 2.5,color: Colors.red,),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 10,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisSize:MainAxisSize.min,
                                  children: [
                                    Container(
                                      // color:Colors.red,
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<ProductModel>(
                                              isDense: true,
                                              icon:Icon(Icons.arrow_drop_down),
                                              hint: Text("Select Product", style: TextStyle(
                                                fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                )),
                                              value: sel_product[index],
                                              //cartData.cartItemName[index].productName,
                                              isExpanded: true,

                                              onTap: (){

                                              },
                                              onChanged: (product){
                                                setState(() {
                                                  cartData.returncartItemName[index].itemcountController.text="1";

                                                  sel_product[index]=product;
                                                  cartData.returncartItemName[index].itemCount=1;
                                                  // cartData.cartItemName[index].itemPrice= product.price??0;

                                                  cartData.returncartItemName[index].itemPrice= product.productPrice[0].price??0;

                                                  //cartData.cartItemName[index].subTotalPrice = product.price??0;

                                                  cartData.returncartItemName[index].subTotalPrice = product.productPrice[0].price??0;
                                                  // cartData.cartItemName[index].productName = product;
                                                  cartData.returncartItemName[index].productName = product;
                                                });
                                                print("selected product is"+product.productCode+product.productMainType);
                                              },
                                              style: TextStyle(    fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                ),
                                              items:
                                              widget.product.map<DropdownMenuItem<ProductModel>>((ProductModel item) {
                                                return DropdownMenuItem<ProductModel>(
                                                  value: item,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:0.0),
                                                    child: VariableText(
                                                      text: item.name.toString(),
                                                      fontsize:12,fontcolor: textcolorblack,
                                                      weight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                      ),
                                                  ),
                                                );
                                              }).toList()
                                          )),
                                    ),
                                    VariableText(
                                      // text: orderDetails['order'][index]['itemPrice'],
                                      text: 'Rs.'+ cartData.returncartItemName[index].itemPrice.toString()??0,
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: 'Total',
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                    ),
                                    SizedBox(height:height*0.0025,),
                                    VariableText(
                                      text:'Rs.'+ cartData.returncartItemName[index].subTotalPrice.toString()??0,
                                      fontsize:12,fontcolor: themeColor1,
                                      weight: FontWeight.w700,

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height:height*sizedboxvalue,),
                ],
              );
            })
        //SizedBox(height:height*sizedboxvalue,),


      ],
    );

  }
  Widget customShopDetailsContainer(
      {double height,
        double width,
        String address,
        String shopname,
        String imageurl}) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xffE0E0E099).withOpacity(0.6),
        )
      ], color: themeColor2),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: height * 0.08,
                decoration: BoxDecoration(
                  //color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LayoutBuilder(
                    builder: (_, constraints) => Image.network(
                        imageurl.toString() == "No Image" || imageurl == null
                            ? "https://i.stack.imgur.com/y9DpT.jpg"
                            : imageurl.split('{"')[1].split('"}')[0],
                        fit: BoxFit.fill, loadingBuilder: (BuildContext context,
                        Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                //width: width*0.70,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: height*0.0055,),
                      VariableText(
                        text: shopname,
                        fontsize: 15,
                        fontcolor: textcolorblack,
                        weight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: VariableText(
                                text: address,//
                                //text: widget.shopDetails.customerAddress,
                                fontsize: 11, fontcolor: textcolorgrey,
                                line_spacing: 1.1,
                                textAlign: TextAlign.start,
                                max_lines: 5,
                                weight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.008,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  double calculatePrice({int quantity,ProductModel productDetils}){
    double dynamicprice;
    for(var item in productDetils.productPrice){

      if(item.min<=quantity && item.max>=quantity){
        setState(() {
          dynamicprice= double.parse(item.price.toStringAsFixed(2));
        });
      }
    }
    return dynamicprice;

  }
  ///static price
  // api here
/*  Widget orderDetailsBlock(RetrunCartModel cartData,double height,double width,){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenpadding),
              child: VariableText(
                text: 'ITEMS',
                fontsize:12,fontcolor: textcolorgrey,
                weight: FontWeight.w500,
                fontFamily: fontMedium,
              ),
            ),
          ],
        ),
        SizedBox(height:height*sizedboxvalue,),
        isLoading ? Container(
            height: height*0.30,
            width: width,
            child: ProcessLoadingWhite()) :
        cartData.returncartItemName.length<1?Container(
          height: height*0.35,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VariableText(text: "No item Added",)
            ],
          ),
        ):
        ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cartData.returncartItemName.length,
            physics: ScrollPhysics(),
            //itemCount: product.length,
            itemBuilder: (BuildContext context,int index){
              for(int i=0;i<cartData.returncartItemName.length;i++){
                sel_product.add(null);
              }
              return  Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenpadding),
                    child: Container(
                      // height: height*0.09,
                      decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(
                            color:Color(0xffE0E0E099).withOpacity(0.6),)],
                          color: themeColor2
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: screenpadding/2),
                        child: Row(
                          children: [
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap:(){
                                  if( cartData.returncartItemName.length<=1){
                                    Fluttertoast.showToast(
                                        msg: "You can't clear cart",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                  else{
                                    cartData.returncartItemName.removeAt(index);
                                    sel_product.removeAt(index);
                                    setState(() {
                                    });}

                                },
                                child: Container(
                                  child: Image.asset('assets/icons/delete.png',scale: 3.5,),
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue/2,),
                            Expanded(
                              flex: 4,
                              child:
                              Container(
                                // height: height*0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Color(0xffF6821F).withOpacity(0.6)),
                                  color: Color(0xffF6821F).withOpacity(0.5),

                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){

                                          if(   sel_product[index]!=null){
                                            if( cartData.returncartItemName[index].itemCount>1){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount--;
                                                cartData.returncartItemName[index].itemcountController.text=cartData.returncartItemName[index].itemCount.toString();
                                                cartData.returncartItemName[index].subTotalPrice= cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount;
                                              });
                                            }}
                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Please select product",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white,
                                                fontSize: 16.0);

                                            print("Please select product ");
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                          ),
                                          height: height*0.04,

                                          child: Image.asset('assets/icons/minus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:3,
                                      child: Container(
                                        height: height*0.04,
                                        color: themeColor2,
                                        child: Center(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical: TextAlignVertical.center,
                                            controller:cartData.returncartItemName[index].itemcountController,

                                            decoration:InputDecoration(
                                              hintText:cartData.returncartItemName[index].itemCount.toString(),
                                              hintStyle: TextStyle(
                                                fontSize:13,color: themeColor1,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,),

                                              contentPadding: EdgeInsets.all(2),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,),

                                            ),
                                            readOnly:sel_product[index]==null?true:false,
                                            onChanged: (value){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount=int.parse(value, onError: (source) => 0);
                                                cartData.returncartItemName[index].subTotalPrice= cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount??1;

                                              });
                                            },

                                            style: TextStyle(
                                              fontSize:13,color: themeColor1,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fontMedium,),
                                          ),

                                          *//* child: VariableText(
                                           text: cartData.cartItemName[index].itemCount.toString(),
                                            fontsize:13,fontcolor: themeColor1,
                                            weight: FontWeight.w500,
                                            fontFamily: fontMedium,
                                            max_lines: 1,
                                          ),*//*
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: (){
                                          print(sel_product[index]);

                                          if( sel_product[index]!=null){
                                            if(cartData.returncartItemName[index].itemCount>=0){
                                              setState(() {
                                                cartData.returncartItemName[index].itemCount++;
                                                cartData.returncartItemName[index].itemcountController.text=cartData.returncartItemName[index].itemCount.toString();
                                                cartData.returncartItemName[index].subTotalPrice= cartData.returncartItemName[index].itemPrice*cartData.returncartItemName[index].itemCount;
                                              });
                                            }}

                                          else{
                                            Fluttertoast.showToast(
                                                msg: "Please select product",
                                                toastLength: Toast.LENGTH_SHORT,
                                                backgroundColor: Colors.black87,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }

                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),

                                          ),
                                          height: height*0.04,
                                          child: Image.asset('assets/icons/plus.png',scale: 2.5,),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 10,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisSize:MainAxisSize.min,
                                  children: [
                                    Container(
                                      // color:Colors.red,
                                      child: DropdownButtonHideUnderline(
                                          child: DropdownButton<ProductModel>(
                                              isDense: true,
                                              icon:Icon(Icons.arrow_drop_down),
                                              hint: Text("Select Product", style: TextStyle(
                                                fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,)),
                                              value: sel_product[index],
                                              //cartData.cartItemName[index].productName,
                                              isExpanded: true,

                                              onTap: (){

                                              },
                                              onChanged: (product){
                                                setState(() {
                                                  cartData.returncartItemName[index].itemcountController.text="1";

                                                  sel_product[index]=product;
                                                  cartData.returncartItemName[index].itemCount=1;
                                                  cartData.returncartItemName[index].itemPrice= product.price??0;
                                                  cartData.returncartItemName[index].subTotalPrice = product.price??0;
                                                  cartData.returncartItemName[index].productName = product;
                                                  //print(cartData.cartItemName[index].cartItemName.name);
                                                  //  print("Selected prod is: "+sel_issue.id.toString()+" "+sel_issue.name);
                                                });
                                              },
                                              style: TextStyle(    fontSize:12,color: textcolorblack,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontMedium,),
                                              items:
                                              widget.product.map<DropdownMenuItem<ProductModel>>((ProductModel item) {
                                                return DropdownMenuItem<ProductModel>(
                                                  value: item,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left:0.0),
                                                    child: VariableText(
                                                      text: item.name.toString(),
                                                      fontsize:12,fontcolor: textcolorblack,
                                                      weight: FontWeight.w500,
                                                      textAlign: TextAlign.start,
                                                      fontFamily: fontMedium,),
                                                  ),
                                                );
                                              }).toList()
                                          )),
                                    ),
                                    VariableText(
                                      // text: orderDetails['order'][index]['itemPrice'],
                                      text: 'Rs.'+ cartData.returncartItemName[index].itemPrice.toString()??0,
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:height*sizedboxvalue,),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    VariableText(
                                      text: 'Total',
                                      fontsize:10,fontcolor: Color(0xff828282),
                                      weight: FontWeight.w400,
                                      fontFamily: fontRegular,
                                    ),
                                    SizedBox(height:height*0.0025,),
                                    VariableText(
                                      text:'Rs.'+ cartData.returncartItemName[index].subTotalPrice.toString()??0,
                                      fontsize:12,fontcolor: themeColor1,
                                      weight: FontWeight.w700,
                                      fontFamily: fontRegular,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height:height*sizedboxvalue,),
                ],
              );
            })
        //SizedBox(height:height*sizedboxvalue,),


      ],
    );

  }*/
  List<ReturnCartItem> temp = [];
  Widget orderSummaryBlock(RetrunCartModel cartData,double height,double width){
   /* int subtotal=0;
    for(int i=0;i<cartData.returncartItemName.length;i++){
      subtotal+=cartData.returncartItemName[i].itemCount*cartData.returncartItemName[i].productName.price.toInt();
    }*/
    int subtotal=0;
    for(int i=0;i<cartData.returncartItemName.length;i++){
      //  subtotal+=cartData.cartItemName[i].itemCount*cartData.cartItemName[i].productName.price.toInt();
      subtotal+=cartData.returncartItemName[i].itemCount*
          cartData.returncartItemName[i].itemPrice;
          cartData.returncartItemName[i].itemPrice;

      //cartData.cartItemName[i].productName.productPrice[0].price;
    }

    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            //  height: height*0.07,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: themeColor1.withOpacity(0.6)),
                color: themeColor1.withOpacity(0.25)
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15/2),
              child: Column(
                children: [
                  SizedBox(height: height*0.015,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/icons/ledger.png',scale: 8.5,color: themeColor1,),
                      SizedBox(width: height*0.0055,),
                      VariableText(
                        text:  'Return Summary',
                        fontsize:14,fontcolor: textcolorblack,
                        weight: FontWeight.w700,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.01,),
                  ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:cartData.returncartItemName.length ,
                      itemBuilder: (BuildContext context,int i){
                        bool repeated = false;
                        int totalCount = cartData.returncartItemName[i].itemCount;
                        for(int j=i+1; i<cartData.returncartItemName.length && j < cartData.returncartItemName.length; j++){
                          if(cartData.returncartItemName[i].productName.productCode ==
                              cartData.returncartItemName[j].productName.productCode){
                            totalCount += cartData.returncartItemName[j].itemCount;
                          }
                        }
                        for(int k=0; k<temp.length; k++){
                          if(temp[k].productName.productCode == cartData.returncartItemName[i].productName.productCode){
                            return Container();
                          }
                        }
                        temp.add(cartData.returncartItemName[i]);
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex:2,
                                  child: VariableText(
                                    text: totalCount.toString()+"x"??0,
                                    fontsize:13,fontcolor: textcolorblack,
                                    weight: FontWeight.w600,
                                    line_spacing:1.2 ,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(width: height*0.008,),
                                Expanded(
                                  flex:12,
                                  child: VariableText(
                                    text:  cartData.returncartItemName[i].productName.name.toString(),
                                    fontsize:13,fontcolor: textcolorblack,
                                    weight: FontWeight.w400,
                                    textAlign: TextAlign.start,
                                    line_spacing:1.2 ,
                                    max_lines: 2,
                                  ),
                                ),
                                Expanded(
                                  flex:4,
                                  child: Container(
                                    child: VariableText(
                                      text:      (cartData.returncartItemName[i].itemCount*cartData.returncartItemName[i].itemPrice).toString(),
                                      //(cartData.returncartItemName[i].itemCount*cartData.returncartItemName[i].productName.price).toString(),
                                      fontsize:13,fontcolor: textcolorblack,
                                      weight: FontWeight.w400,
                                      line_spacing:1.2 ,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height*0.0025,),
                          ],
                        );

                      }),
                  SizedBox(height: height*0.01,
                  ),
                  Container(height: 1,
                    color: themeColor1,),
                  SizedBox(height: height*0.01,
                  ),

                  Row(
                    children: [
                      VariableText(
                        text:  'Sub Total',
                        fontsize:14,fontcolor: textcolorgrey,
                        weight: FontWeight.w400,
                      ),
                      Spacer(),
                      VariableText(
                        text:
                        'Rs. ${ f.format(double.parse(subtotal.toString()))}',

                        fontsize:14,fontcolor: textcolorgrey,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: height*0.015,),


                ],
              ),
            ),

          ),
        ),

        SizedBox(height:height*sizedboxvalue,),

      ],
    );

  }
  void postReturnOrder(RetrunCartModel cartData,) async{
    try {
      setLoading2(true);
      var response =await  OnlineDataBase.postReturnOrder(cartData:cartData,lat:widget.lat.toString(),long:widget.long.toString(),customerCode:widget.shopDetails.customerCode);

      print("Response is" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>SucessFullyReturnScreen(shopDetails: widget.shopDetails,lat: widget.lat,long: widget.long,)));
        Provider.of<RetrunCartModel>(context,listen:false).retrunclearCart();
        setLoading2(false);
      }
      else if(response.statusCode == 401){
        setLoading2(false);
      }
      else {
        Fluttertoast.showToast(
            msg: "Internet issue",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0);
        setLoading2(false);


      }
    } catch (e, stack) {
      print('exception is'+e.toString());
      setLoading2(false);
      Fluttertoast.showToast(
          msg: "Error: " +e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  setLoading(bool loading){
    setState(() {
      isLoading=loading;
    });
  }
  setLoading2(bool loading){
    setState(() {
      isLoading2=loading;
    });
  }
}

