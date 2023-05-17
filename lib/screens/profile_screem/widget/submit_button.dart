import 'package:flutter/material.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';

class SubmitButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  const SubmitButton({
    Key? key,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                'Submit',
                fontColor: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
      ),
    );
  }
}
