import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skr_delivery/screens/widget/common.dart';
import 'package:skr_delivery/screens/widget/constant.dart';
class CustomerWallet extends StatelessWidget {
  CustomerWallet(
      {this.height,
        this.f,
        this.walletCapacity,
        this.availableBalances,
        this.useBalance});

  final double height;
  final NumberFormat f;
  final availableBalances;
  final useBalance;
  final walletCapacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(
                5,
                246,
                130,
                31,
              ),
              boxShadow: [BoxShadow(color: themeColor1.withOpacity(0.25))]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    VariableText(
                      text: 'Wallet Capacity: ',
                      fontsize: 14,
                      fontcolor: themeColor1,
                      weight: FontWeight.w500,
                    ),
                    Spacer(),
                    VariableText(
                      text: "Rs. " + f.format(double.parse(walletCapacity.toString())),
                      fontsize: 14,
                      fontcolor: Colors.deepOrange,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 1,
                    color: themeColor1,
                  ),
                ),
                Row(
                  children: [
                    VariableText(
                      text: 'Used balance: ',
                      fontsize: 14,
                      fontcolor: textcolorblack,
                      weight: FontWeight.w500,
                    ),
                    Spacer(),
                    VariableText(
                      text: "Rs " + f.format(double.parse(useBalance.toString())),
                      fontsize: 14,
                      fontcolor: textcolorblack,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.0075,
                ),
                Row(
                  children: [
                    VariableText(
                      text: 'Available balance: ',
                      fontsize: 14,
                      fontcolor: textcolorblack,
                      weight: FontWeight.w500,
                    ),
                    Spacer(),
                    VariableText(
                      text: "Rs. " + f.format(double.parse(availableBalances.toString())),
                      fontsize: 14,
                      fontcolor: themeColor1,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}