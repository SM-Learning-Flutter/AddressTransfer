import 'package:flutter/material.dart';

class SimpleTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;
  final Color? color;
  final int? maxLine;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const SimpleTextWidget(
      {Key? key,
        required this.text,
        required this.fontSize,
        this.maxLine,
        this.fontFamily = "pretendardMedium",
        this.color,
        this.decoration,
        this.overflow,
        this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLine,
      style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          color: color,
          decoration: decoration,
          fontWeight: FontWeight.w500,
          overflow: overflow),
    );
  }
}
