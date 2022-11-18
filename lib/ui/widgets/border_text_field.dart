
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BorderTextField extends StatelessWidget {
  final String labelText;
  final double labelFontSize;
  final String? labelFontFamily;
  final Color? labelColor;
  final TextAlign textAlign;
  final BorderRadius borderRadius;
  final Color borderColor;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController? controller;
  final Icon? icon;
  final Color? iconColor;
  final GestureTapCallback? onClick;
  final ValueChanged<String>? onChange;

  const BorderTextField ({
    Key? key,
    required this.labelText,
    required this.labelFontSize,
    this.labelFontFamily,
    this.labelColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.borderColor = Colors.white60,
    this.textAlign = TextAlign.left,
    this.inputType,
    this.inputFormatter,
    this.controller,
    this.icon,
    this.onClick,
    this.iconColor,
    this.onChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: textAlign,
      obscureText: false,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              color: labelColor,
              fontSize: labelFontSize,
              fontFamily: labelFontFamily
          ),
          prefixIconColor: iconColor,
          prefixIcon: InkWell(
              onTap: onClick,
              child: icon
          ),
          border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor)
          ),
          filled: true,
          fillColor: Colors.white
      ),
      onChanged: onChange,
      keyboardType: inputType,
      inputFormatters: inputFormatter,
      controller: controller,
    );
  }
}