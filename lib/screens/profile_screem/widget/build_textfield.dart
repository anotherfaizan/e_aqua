import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  BuildTextField({
    Key? key,
    required this.hintText,
    this.readOnly,
    this.maxLines,
    this.height,
    this.suffixIcon,
    this.keyboardType,
    this.contentPadding,
    this.validator,
    this.controller,
    this.onTap,
    this.maxLength,
  }) : super(key: key);

  final String hintText;
  final bool? readOnly;
  final int? maxLines;
  final double? height;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function()? onTap;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onTap: onTap,
          maxLength: maxLength,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.done,
          validator: validator,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          readOnly: readOnly ?? false,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: contentPadding ?? EdgeInsets.only(left: 10),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(15.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
