import 'package:aquatic_vendor_app/app_providers/order_provider.dart';
import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/repositories/order_reposiory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageOrderListItem extends StatefulWidget {
  final Map data;
  ManageOrderListItem({Key? key, required this.data}) : super(key: key);

  @override
  State<ManageOrderListItem> createState() => _ManageOrderListItemState();
}

class _ManageOrderListItemState extends State<ManageOrderListItem> {
  late OrderProvider _orderProvider;
  List<String> _orderStatusList = [
    'Accepted',
    'Packed',
    'Ready to Dispatch',
    'Out for Delivery',
  ];

  late String _currentOrderStatus;

  @override
  void initState() {
    super.initState();
    _orderProvider = Provider.of(context, listen: false);
    _currentOrderStatus = widget.data['order_status'];
  }

  double _calculatePrice() {
    int quantity = int.parse(widget.data['quantity'].toString());
    double price = double.parse(widget.data['price'].toString());
    return (price * quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildRichText('Order Number: ', '${widget.data['order_id']}'),
                buildText(
                  formatedDate(
                    date: widget.data['order_created_at'],
                    format: AppDateFormat.yyyymmddHHmmss,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontColor: AppColors.PrimaryColor,
                ),
              ],
            ),
            sizedBox(),
            buildRichText(
              'Name : ',
              padQuotes(widget.data['product_name']),
            ),
            sizedBox(),
            buildRichText(
              'Price: ',
              'Rs ${_calculatePrice().toStringAsFixed(0)}',
            ),
            sizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildRichText('Quantity: ', '${widget.data['quantity']}'),
                _statusButton(),
              ],
            ),
            sizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildRichText(String t1, String t2) {
    return RichText(
      text: TextSpan(
        style:
            TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Poppins'),
        children: [
          TextSpan(
            text: t1,
          ),
          TextSpan(
            text: t2,
            style: TextStyle(
                fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget sizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  Widget _statusButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.brightGreen, //Colors.red
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ), //Elevated Button Background
      onPressed: () {}, //make onPressed callback empty
      child: DropdownButton(
        alignment: Alignment.center,
        style: TextStyle(
          color: Colors.white,
        ), //Dropdown font color
        dropdownColor:
            AppColors.brightGreen, // //dropdown menu background color
        icon: Icon(
          Icons.expand_more,
          color: Colors.white,
          size: 20,
        ), //dropdown indicator icon
        underline: Container(), //make underline empty
        value: _currentOrderStatus,
        onChanged: (value) async {
          setState(() {
            _currentOrderStatus = value.toString();
          });

          _orderProvider.updateOrder(
            context: context,
            orderId: '${widget.data['order_id']}',
            storeId: '${widget.data['store_id']}',
            orderStatus: _currentOrderStatus,
          );
        },
        items: _orderStatusList.map((itemone) {
          return DropdownMenuItem(
            value: itemone,
            child: Text(itemone),
          );
        }).toList(),
      ),
    );
  }
}
