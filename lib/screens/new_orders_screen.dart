import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/new_order_item.dart';
import 'package:flutter/material.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          'New Orders',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: NewOrderItem(),
        ),
      ),
    );
  }
}
