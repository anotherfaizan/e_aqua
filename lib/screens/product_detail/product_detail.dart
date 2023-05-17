import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/details_screen/components/build_listview_details.dart';
import 'package:aquatic_vendor_app/MockData/mockdata.dart';
import 'package:aquatic_vendor_app/screens/manage_orders/manage_orders_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/info_list.dart';

class ProductDetail extends StatefulWidget {
  final Map data;

  ProductDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final List<Map<String, dynamic>> detailData = [
    {
      'image': 'pet_age_big.png',
      'title': '3.2 Years',
      'icon': null,
    },
    {
      'image': null,
      'title': 'Male',
      'icon': Icons.male,
    },
    {
      'image': 'weight.png',
      'title': '300g',
      'icon': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    Widget sizedBox({double? height}) {
      return SizedBox(
        height: height ?? 10,
      );
    }

    List<Widget> buildDetailsRow(String text1, String text2) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText(
              text1,
              fontColor: Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            buildText(
              text2,
              fontColor: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ],
        ),
        sizedBox(),
      ];
    }

    changeStatusColor(context, Colors.transparent);

    return Scaffold(
      appBar: buildAppbar(context),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 350,
                    width: double.infinity,
                    child: Image.asset(
                      AppConstants.assetImages + 'fish_pic.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // sizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        sizedBox(),
                        sizedBox(),
                        buildHorizontalList(),
                        sizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildText(
                              'Gold Fish',
                              // fontColor: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            buildText(
                              '₹ ${widget.data['price']}/-',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ],
                        ),
                        sizedBox(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: buildText('About this pet',
                              fontColor: Colors.grey[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        sizedBox(),
                        buildText(
                          padQuotes(widget.data['full_description']),
                          alignment: TextAlign.left,
                          fontColor: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        sizedBox(height: 20),
                        InfoList(data: widget.data),

                        sizedBox(height: 20),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: buildText(
                            'Other Details',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        sizedBox(),
                        // sizedBox(height: 20),
                        ...buildDetailsRow('Color', 'Red'),

                        ...buildDetailsRow('Sub name', 'Gold Fish'),
                        ...buildDetailsRow('Country origin', 'China'),
                        sizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned buildSharePositioned() {
    return Positioned(
      bottom: 80,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.share,
          color: AppColors.PrimaryColorDark,
          size: 40,
        ),
      ),
    );
  }

  Positioned buildShoppingPositioned() {
    return Positioned(
      bottom: 10,
      left: 80,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 40,
          color: AppColors.PrimaryColorDark,
        ),
      ),
    );
  }

  Positioned buildChatPositioned() {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Image.asset(
          AppConstants.assetImages + 'chat.png',
          fit: BoxFit.cover,
          height: 35,
          width: 35,
        ),
      ),
    );
  }

  Positioned buildFavourites() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(
          Icons.favorite_border,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
  }

  Widget buildBottomButton({
    String? text,
    Color? buttonColor,
    Color? borderColor,
    Color? textColor,
    void Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(10),
          primary: buttonColor,
          side: BorderSide(
            width: 2,
            color: borderColor ?? Colors.transparent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: buildText(
          text ?? '',
          fontColor: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Container buildHorizontalList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 100),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(AppConstants.assetImages + 'fish_pic.png'),
          ),
        ),
      ),
    );
  }

  RichText builtPrice() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Price  ',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: '₹ 1203.00',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget buildAppbar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leadingWidth: 65,
    leading: Container(
      height: 40,
      width: 60,
      // padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 3,
          color: Colors.black,
        ),
        color: Colors.white,
      ),
      child: FittedBox(
        child: Center(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () {
              navigationPop(context);
            },
          ),
        ),
      ),
    ),
  );
}
