import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildListViewDetails extends StatelessWidget {
  const BuildListViewDetails({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<Map<String, dynamic>> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          categories.length,
          (i) => buildListItem(i),
          // itemCount: categories.length,
        ),
      ),
    );
  }

  Widget buildListItem(int i) {
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
                child: categories[i]['image'] != null
                    ? FittedBox(
                        child: Image.asset(
                          AppConstants.assetImages + categories[i]['image']!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : FittedBox(
                        child: Icon(
                          categories[i]['icon'],
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
              child: buildText(categories[i]['title']!,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
