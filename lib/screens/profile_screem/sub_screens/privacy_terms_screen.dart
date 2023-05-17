import 'package:aquatic_vendor_app/MockData/mockdata.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, AppColors.backgroundColor);
    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          title,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40, left: 10, right: 10,
            // bottom: 30,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: buildText(
                  MockData.longLorem,
                  fontSize: 16,
                  alignment: TextAlign.justify,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: buildText(
                  MockData.longLorem,
                  fontSize: 16,
                  alignment: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
