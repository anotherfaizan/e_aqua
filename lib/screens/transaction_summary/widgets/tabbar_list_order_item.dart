import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/screens/details_screen/details_screen.dart';
import 'package:aquatic_vendor_app/screens/order_detail/order_detail.dart';
import 'package:aquatic_vendor_app/screens/ordered_product_detail/ordered_product_detail.dart';
import 'package:flutter/material.dart';

class TabBarListOrderItem extends StatefulWidget {
  final Map data;
  const TabBarListOrderItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TabBarListOrderItem> createState() => _TabBarListOrderItemState();
}

class _TabBarListOrderItemState extends State<TabBarListOrderItem> {
  @override
  void initState() {
    super.initState();
  }

  double _calculatePrice() {
    int quantity = int.parse(widget.data['quantity'].toString());
    double price = double.parse(widget.data['price'].toString());
    return (price * quantity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nav(
          context,
          OrderedProductDetail(
            quantity: int.parse(widget.data['quantity'].toString()),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        bottomLeft: Radius.circular(15),
                      ),
                      child: Image.network(
                        ConnectApi.BASE_URL_IMAGE +
                            padQuotes(widget.data['product_image1']),
                        fit: BoxFit.cover,
                        height: 120,
                        errorBuilder: (
                          BuildContext context,
                          Object exception,
                          _,
                        ) {
                          return Image.asset(
                            AppConstants.assetImages + 'placholder.png',
                            fit: BoxFit.cover,
                            height: 120,
                          );
                        },
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: buildText(
                                  padQuotes(widget.data['product_name']),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  maxLine: 1,
                                ),
                              ),
                              Icon(
                                Icons.male,
                                size: 35,
                                color: AppColors.PrimaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          ...buildAge(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              buildText(
                                '₹ ${_calculatePrice().toStringAsFixed(0)}/-',
                                alignment: TextAlign.right,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildAge() {
    return [
      buildItemRow(
        image: 'pet_age.png',
        text: _subtextByType(),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _subtextByType() {
    String text = '';

    switch (widget.data['product_type']) {
      case 'Live product':
        text = padQuotes(widget.data['age']);
        break;
      case 'Food':
        text = padQuotes(widget.data['brand']);
        break;
      case 'AQUARIUM':
        text = padQuotes(widget.data['brand']);
        break;
      case 'Equipment':
        text = padQuotes(widget.data['brand']);
        break;
      case 'Service booking':
        text = '';
        break;
      default:
    }

    return text;
  }
}
