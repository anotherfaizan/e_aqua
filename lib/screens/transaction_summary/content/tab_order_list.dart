import 'package:aquatic_vendor_app/screens/home_screen/widgets/order_item.dart';
import 'package:aquatic_vendor_app/screens/transaction_summary/widgets/tabbar_list_order_item.dart';
import 'package:flutter/material.dart';

class TabOrderList extends StatefulWidget {
  final List allOrdersList;
  final String orderStatus;
  TabOrderList({
    Key? key,
    required this.allOrdersList,
    required this.orderStatus,
  }) : super(key: key);

  @override
  State<TabOrderList> createState() => _TabOrderListState();
}

class _TabOrderListState extends State<TabOrderList> {
  List _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filterListByStatus();
  }

  void _filterListByStatus() {
    widget.allOrdersList.forEach((element) {
      if (element['order_status'] == widget.orderStatus) {
        _filteredList.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        return TabBarListOrderItem(data: _filteredList[index]);
      },
    );
  }
}
