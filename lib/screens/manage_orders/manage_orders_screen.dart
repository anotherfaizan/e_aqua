import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/order_reposiory.dart';
import 'package:aquatic_vendor_app/screens/manage_orders/widgets/mange_order_list_item.dart';
import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  OrderRepository _orderRepository = OrderRepository();

  late Future _getData;

  List _orderList = [];

  @override
  void initState() {
    _getData = _getAllOrders();
    super.initState();
  }

  Future _getAllOrders() async {
    Map res = await _orderRepository.getAllVendorOrders();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          'Manage Orders',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: FutureBuilder(
          future: _getData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map data = snapshot.data as Map;
              _orderList = data['order'];
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _orderList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ManageOrderListItem(
                  data: _orderList[index],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
