
import 'package:flutter/material.dart';

class ShowLocationAndRefresh extends StatelessWidget {
  ShowLocationAndRefresh({this.localArea, this.city, this.onTap});
  final localArea;
  final city;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: Text(
                  "Current Location",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "${localArea},${city}",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
          InkWell(
              onTap: onTap,
              child: Icon(
                Icons.refresh,
                color: Colors.red,
                size: 30,
              )),
        ],
      ),
    );
  }
}