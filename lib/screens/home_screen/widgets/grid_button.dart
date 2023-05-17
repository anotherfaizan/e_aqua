import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridButtons extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String count;
  final Color? color;
  const GridButtons({
    Key? key,
    required this.gridData,
    required this.i,
    this.onPressed,
    required this.title,
    required this.count,
    this.color,
  }) : super(key: key);

  final List<Map<String, dynamic>> gridData;
  final int i;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        primary: color,
      ),
      onPressed: onPressed,
      /* () {
        nav(context, gridData[i]['screen']);
      } */
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildText(
            title,
            fontColor: Colors.white,
            fontSize: 14,
          ),
          buildText(
            count,
            fontColor: Colors.white,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}
