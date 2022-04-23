import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skr_delivery/screens/widget/constant.dart';

class RectangluartextFeild extends StatelessWidget {
  final String text;
  final bool enable, obscureText;
  final Function onChanged;
  final TextEditingController cont;
  final String hinttext;

  //FieldIcon icon;
  final bool texthidden, readonly, expands;
  final double radius;
  final TextInputType keytype;

  // final FocusNode focusNode;

  final Color color, containerColor, bordercolor;
  final Color hintTextColor;
  final int length;
  final int textlength;
  final bool enableborder;

  //final Array inputFormatter;
  final Function onSubmit;

  final double fontsize;
  final String obscuringCharacter;

  const RectangluartextFeild({
    this.textlength = 20,
    this.text = "temp",
    this.enable = true,
    this.enableborder = true,
    this.onChanged,
    this.obscureText = false,
    this.keytype = TextInputType.text,
    this.color = themeColor2,
    this.hintTextColor = hinttextColor,
    this.hinttext = "temp",
    this.bordercolor = feildBorderColor,
    this.containerColor = feildContainerColor,
    this.cont,
    this.onSubmit,
    this.texthidden = false,
    this.readonly = false,
    this.expands = false,
    this.radius = 0,
    this.length = 5,
    this.obscuringCharacter = "*",
    this.fontsize = 14,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;
    double radius = 10;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
          // border: Border.all(color: enableborder?bordercolor:Colors.transparent)
        ),
        height: height * 0.065,
        child: TextFormField(
          enabled: enable,
          inputFormatters: [
            LengthLimitingTextInputFormatter(textlength),
          ],
          obscureText: obscureText,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: textcolorblack),
          onChanged: onChanged,
          controller: cont,
          onFieldSubmitted: onSubmit,
          keyboardType: keytype,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Number';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: enableborder ? bordercolor : Color(0xffEEEEEE))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: enableborder ? bordercolor : Color(0xffEEEEEE))),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hintText: hinttext,
            contentPadding: EdgeInsets.only(top: 15, bottom: 0, left: 14),
            hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: hintTextColor),
          ),
        ));
  }
}