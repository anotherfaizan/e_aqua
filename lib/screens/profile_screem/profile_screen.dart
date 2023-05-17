import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/choose_plan_screen.dart';
import 'package:aquatic_vendor_app/screens/manage_orders/manage_orders_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/bank_details/bank_detail.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/bank_details_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/personal_details_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/privacy_terms_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/store_details_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/background_stack_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/start_selling.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../chat_screen/chat_screen.dart';
import 'content/personal_details/personal_details.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final String? fontFamily = GoogleFonts.poppins().fontFamily;

  @override
  Widget build(BuildContext context) {
    Widget buildProfileItem(
      String text, {
      void Function()? onTap,
      IconData? icon,
      String? image,
    }) {
      return Card(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: ListTile(
            tileColor: Colors.white,
            onTap: onTap,
            leading: CircleAvatar(
              backgroundColor: AppColors.backgroundColor,
              child: image == null
                  ? Icon(
                      icon,
                      color: AppColors.PrimaryColor,
                    )
                  : Image.asset(AppConstants.assetImages + image),
            ),
            title: buildText(
              text,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontColor: Colors.black,
              alignment: TextAlign.left,
            ),
          ),
        ),
      );
    }

    changeStatusColor(context, AppColors.backgroundColor);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          'Profile',
          fontColor: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            buildProfileItem(
              'Personal Details',
              image: 'user.png',
              onTap: () {
                nav(context, PersonalDetails());
              },
            ),
            buildProfileItem(
              'Store details',
              image: 'store.png',
              onTap: () {
                nav(context, StoreDetail());
              },
            ),
            buildProfileItem(
              'Bank details',
              image: 'bank.png',
              onTap: () {
                nav(context, BankDetail());
              },
            ),
            buildProfileItem(
              'Plans',
              image: 'bank.png',
              onTap: () {
                nav(context, ChoosePlanScreen(navBack: true));
              },
            ),
            buildProfileItem(
              'Manage Orders',
              image: 'bank.png',
              onTap: () {
                nav(context, ManageOrdersScreen());
              },
            ),
            buildProfileItem(
              'Chat With Us',
              image: 'chat.png',
              onTap: () {
                nav(context, ChatScreen());
              },
            ),
            buildProfileItem(
              'Terms and conditions',
              image: 'check.png',
              onTap: () {
                nav(
                    context,
                    PrivacyTermsScreen(
                      title: 'Terms and conditions',
                    ));
              },
            ),
            buildProfileItem(
              'Privacy and policy',
              image: 'open_book.png',
              onTap: () {
                nav(
                    context,
                    PrivacyTermsScreen(
                      title: 'Privacy and policy',
                    ));
              },
            ),
            buildProfileItem(
              'Log Out',
              image: 'logout.png',
              onTap: () {
                //clear hive
                ConnectHiveSessionData.clear;

                //remove and navigate to start screen
                navigationRemove(
                  context,
                  BackgroundStackScreen(
                    screenNo: 1,
                    content: StartSelling(),
                  ),
                );

                // navigationPushReplacement(context, IntroScreen());
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
