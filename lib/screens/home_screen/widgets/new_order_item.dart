import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/details_screen/details_screen.dart';
import 'package:flutter/material.dart';

class NewOrderItem extends StatelessWidget {

  const NewOrderItem({
    Key? key,
    this.withRemove,
    this.fontFamily,
  
  }) : super(key: key);
  final String? fontFamily;
  final bool? withRemove;

  @override
  Widget build(BuildContext context) {
    List<Widget> buildAge() {
      return [
        buildItemRow(
          image: 'pet_age.png',
          text: '2 months old',
        ),
        SizedBox(
          height: 5,
        ),
        // buildItemRow(
        //   icon: Icons.location_pin,
        //   text: '3.5KM + | ISRO Layout',
        // ),
      ];
    }

    return GestureDetector(
      onTap: () {
        nav(context, DetailsScreen());
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  // height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft:
                                Radius.circular(withRemove == true ? 0 : 15),
                          ),
                          child: Image.asset(
                            AppConstants.assetImages + 'fish_pic.png',
                            fit: BoxFit.cover,
                            height: withRemove == true ? 130 : 120,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildText(
                                'Gold Fish',
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                fontSize: 16,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...buildAge(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 5,
                  child: buildText(
                    '₹ 300/-',
                    alignment: TextAlign.right,
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.male,
                    size: 35,
                    color: AppColors.PrimaryColor,
                  ),
                ),
              ],
            ),
            withRemove == true
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: buildText(
                      'Remove',
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Row buildItemRow({
    String? image,
    IconData? icon,
    String? text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.lightBlue[100],
          radius: 15,
          child: image == null
              ? Icon(
                  icon,
                  color: AppColors.PrimaryColor,
                )
              : Image.asset(
                  AppConstants.assetImages + image,
                  fit: BoxFit.fill,
                ),
        ),
        SizedBox(
          width: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: buildText(
            text!,
            fontColor: Colors.grey[600],
            alignment: TextAlign.left,
            fontFamily: fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
