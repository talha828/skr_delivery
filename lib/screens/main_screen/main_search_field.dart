import 'package:flutter/material.dart';

class MainSearchField extends StatelessWidget {
  MainSearchField({this.onTap,this.onchange,this.enable,this.controller});
  final onTap;
  final onchange;
  final enable;
  final controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      decoration: BoxDecoration(
          border:
          Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        onChanged: onchange,
        controller: controller,
        onTap: onTap,
        enabled: enable,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
            hintText: "Search by Shop Name",
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: Icon(Icons.search)),
      ),
    );
  }
}