import 'package:flutter/material.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  final String? title;
  final EdgeInsetsGeometry? margin;
  final double? padding;
  final double? height;
  final double? width;
  const AppButton({
    Key? key,
    this.onPressed,
    this.isLoading = false,
    this.title,
    this.margin,
    this.height,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: padding ?? 30,
          ),
          primary: AppColors.brightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                height: 16.0,
                width: 16.0,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : buildText(
                title ?? 'Submit',
                fontColor: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
      ),
    );
  }
}
