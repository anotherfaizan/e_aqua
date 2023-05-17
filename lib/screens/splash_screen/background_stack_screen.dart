import 'dart:math';

import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:flutter/material.dart';

class BackgroundStackScreen extends StatelessWidget {
  BackgroundStackScreen({
    Key? key,
    this.visible: true,
    this.screenNo: 1,
    required this.content,
  }) : super(key: key);

  final bool? visible;
  final Widget content;
  final int screenNo;

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, Colors.transparent);
    return Container(
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            screenNo == 1
                ? AppConstants.assetImages + 'first_splash.png'
                : screenNo == 2
                    ? AppConstants.assetImages + 'second_splash.png'
                    : AppConstants.assetImages + 'third_splash.png',
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: content,
      ),
      //  Container(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   color: AppColors.PrimaryColorDark,
      //   child: Stack(
      //     children: [
      //       buildGoldFishPositioned(context),
      //       if (screenNo == 1) buildCircleOnePositioned(context),
      //       if (screenNo == 1) buildCircleTwoPositioned(context),
      //       if (screenNo == 1) buildSquareOnePositioned(context),
      //       if (screenNo == 1) buildSquareTwoPositioned(context),
      //       if (screenNo == 2 || screenNo == 3) buildFish4Positioned(),
      //       if (screenNo == 2 || screenNo == 3)
      //         buildYellowFishTailPositioned(context),
      //       buildFish3Positioned(context),
      //       buildFish2Positioned(context),
      //       buildRedFishPositioned(context),
      //       content,
      //     ],
      //   ),
      // ),
    );
  }

  Positioned buildYellowFishTailPositioned(BuildContext context) {
    return Positioned(
      right: 0,
      top: MediaQuery.of(context).size.height * 0.15,
      child: Container(
        child: Image.asset(AppConstants.assetImages + 'yellow_fish_tail.png'),
      ),
    );
  }

  Positioned buildFish4Positioned() {
    return Positioned(
      right: 20,
      bottom: 150,
      child: Container(
        child: Image.asset(AppConstants.assetImages + 'fish4.png'),
      ),
    );
  }

  Positioned buildRedFishPositioned(BuildContext context) {
    return Positioned(
      right: (screenNo == 2 || screenNo == 3) ? 180 : 30,
      left: (screenNo == 2 || screenNo == 3) ? 10 : 80,
      top: MediaQuery.of(context).size.height * 0.15,
      child: Container(
        height: 130,
        width: 130,
        transform: Matrix4.rotationZ(-1 * pi / 180)..translate(-10.0),
        child: Image.asset(AppConstants.assetImages + 'red_fish.png'),
      ),
    );
  }

  Positioned buildFish2Positioned(BuildContext context) {
    return Positioned(
      left: (screenNo == 2 || screenNo == 3) ? 30 : null,
      right: (screenNo == 2 || screenNo == 3) ? null : 30,
      bottom: MediaQuery.of(context).size.height * 0.4,
      child: Container(
        height: 130,
        width: 130,
        transform: Matrix4.rotationZ(-1 * pi / 180)..translate(-10.0),
        child: Image.asset(AppConstants.assetImages + 'fish2.png'),
      ),
    );
  }

  Positioned buildFish3Positioned(BuildContext context) {
    return Positioned(
      right: (screenNo == 2 || screenNo == 3) ? 30 : null,
      left: (screenNo == 2 || screenNo == 3) ? null : 30,
      top: (screenNo == 2 || screenNo == 3)
          ? null
          : MediaQuery.of(context).size.height * 0.3,
      bottom: (screenNo == 2 || screenNo == 3)
          ? MediaQuery.of(context).size.height * 0.4
          : null,
      child: Container(
        height: 130,
        width: 130,
        transform: Matrix4.rotationZ(-1 * pi / 180)..translate(-10.0),
        child: Image.asset(AppConstants.assetImages + 'fish3.png'),
      ),
    );
  }

  Positioned buildSquareTwoPositioned(BuildContext context) {
    return Positioned(
      right: -250,
      top: 90,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        transform: Matrix4.rotationZ(45 * pi / 180)..translate(-8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(
            width: 10,
            color: AppColors.lightBlue,
          ),
        ),
      ),
    );
  }

  Positioned buildSquareOnePositioned(BuildContext context) {
    return Positioned(
      right: -250,
      top: 20,
      child: Container(
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        transform: Matrix4.rotationZ(45 * pi / 180)..translate(-8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(
            width: 10,
            color: AppColors.lightBlue,
          ),
        ),
      ),
    );
  }

  Positioned buildCircleTwoPositioned(BuildContext context) {
    return Positioned(
      bottom: -180,
      left: -30,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            width: 10,
            color: AppColors.lightBlue,
          ),
        ),
      ),
    );
  }

  Positioned buildCircleOnePositioned(BuildContext context) {
    return Positioned(
      bottom: -150,
      left: -100,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            width: 10,
            color: AppColors.lightBlue,
          ),
        ),
      ),
    );
  }

  Positioned buildGoldFishPositioned(
    BuildContext context,
  ) {
    return Positioned(
      left: 30,
      bottom: (screenNo == 2 || screenNo == 3)
          ? 150
          : MediaQuery.of(context).size.height * 0.3,
      child: Container(
        height: 130,
        width: 130,
        transform: Matrix4.rotationZ(-1 * pi / 180)..translate(-10.0),
        child: Image.asset(AppConstants.assetImages + 'gold_fish.png'),
      ),
    );
  }
}
