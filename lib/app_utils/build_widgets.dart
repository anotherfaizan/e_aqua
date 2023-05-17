import 'package:flutter/material.dart';

Widget buildText(
  String title, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? fontColor,
  TextAlign? alignment,
  String? fontFamily,
  FontStyle? fontStyle,
  int? maxLine,
  TextOverflow? overflow,
}) {
  return Text(
    title,
    textAlign: alignment ?? TextAlign.start,
    style: TextStyle(
      color: fontColor ?? Colors.black,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.w400,
      fontFamily: fontFamily ?? 'Poppins',
      fontStyle: fontStyle,
    ),
    maxLines: maxLine,
    overflow: overflow,
  );
}
