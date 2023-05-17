import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';

import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/enter_phone_number.dart';
import 'package:flutter/material.dart';

class StartSelling extends StatelessWidget {
  const StartSelling({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 200,
          ),
          Spacer(),
          Center(
            child: CircleAvatar(
              // backgroundColor: Color(0xff5F2600),
              radius: 60,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    AppConstants.assetImages + 'a1_logo_home.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          buildText('Keep a track on your business',
              fontColor: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              alignment: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: buildText(
                'Manage your orders and earnings of selling pets in less than a minute with A1 AQUATIC',
                fontColor: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                alignment: TextAlign.center),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 60,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                navigationPushReplacement(context, EnterPhoneNumber());
              },
              child: buildText(
                'Start Selling',
                fontColor: AppColors.PrimaryColorDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
