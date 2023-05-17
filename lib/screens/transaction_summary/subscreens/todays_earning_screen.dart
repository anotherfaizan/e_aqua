import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/new_order_item.dart';
import 'package:flutter/material.dart';

class TodaysEarningsScreen extends StatelessWidget {
  const TodaysEarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: NewOrderItem(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          color: AppColors.brightGreen,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText(
                'Todays Earnings',
                fontColor: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              buildText(
                'Rs 5000',
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
                fontSize: 18,
              )
            ],
          ),
        )
      ],
    );
  }
}
