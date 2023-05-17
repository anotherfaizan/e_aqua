import 'package:aquatic_vendor_app/MockData/mockdata.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        changeStatusColor(context, AppColors.backgroundColor);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          'Notifications',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, i) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.PrimaryColor,
              ),
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  'Your pet was added succesfully',
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 18,
                ),
                buildText(
                  MockData.notificationDescription,
                  fontSize: 16,
                  // fontWeight: FontWeight.w500,
                  alignment: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildText(
                      'Yesterday | 3:00PM',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
