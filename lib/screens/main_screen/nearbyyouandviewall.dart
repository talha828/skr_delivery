import 'package:flutter/material.dart';

class NearByYouAndViewAll extends StatelessWidget {
  NearByYouAndViewAll({this.itemCount, this.onTap});
  final itemCount;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Near By you($itemCount)",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          InkWell(
              onTap: onTap,
              child: Text(
                "View All",
                style: TextStyle(color: Colors.red),
              )),
        ],
      ),
    );
  }
}