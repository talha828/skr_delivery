import 'package:flutter/material.dart';

class VariableText extends StatelessWidget {
  final String text;
  final Color fontcolor;
  final TextAlign textAlign;
  final FontWeight weight;
  final bool underlined, linethrough;
  final double fontsize, line_spacing, letter_spacing;
  final int max_lines;
   VariableText({
    this.text = "A",
    this.fontcolor = Colors.black,
    this.fontsize = 15,
    this.textAlign = TextAlign.center,
    this.weight = FontWeight.normal,
    this.underlined = false,
    this.line_spacing = 1,
    this.letter_spacing = 0,
    this.max_lines = 1,
    this.linethrough = false,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: max_lines,
      textAlign: textAlign,
      style: TextStyle(
        color: fontcolor,
        fontWeight: weight,
        height: line_spacing,
        letterSpacing: letter_spacing,
        fontSize: fontsize,
        decorationThickness: 4.0,
        decoration: underlined
            ? TextDecoration.underline
            : (linethrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}