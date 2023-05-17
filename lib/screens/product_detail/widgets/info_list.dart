import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoList extends StatelessWidget {
  final Map data;
  const InfoList({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          buildListItem(
            title: data['age'] ?? 'NA',
            image: 'pet_age_big.png',
          ),
          buildListItem(
            title: data['gender'] ?? 'NA',
            image: null,
          ),
          buildListItem(
            title: data['weight'] ?? 'NA',
            image: 'weight.png',
          ),
        ],
      ),
    );
  }

  Widget buildListItem({required String title, required String? image}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 100,
      height: 100,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: image != null
                    ? FittedBox(
                        child: Image.asset(
                          AppConstants.assetImages + image,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : FittedBox(
                        child: Icon(
                          Icons.male,
                          color: AppColors.PrimaryColor,
                          size: 40,
                        ),
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.PrimaryColorDark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              width: double.infinity,
              child: buildText(title,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                  fontSize: 16,
                  alignment: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
