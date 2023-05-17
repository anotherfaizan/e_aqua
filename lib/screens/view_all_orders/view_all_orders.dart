import 'package:aquatic_vendor_app/app_resources/firestore_pagination/realtime_pagination.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/order_item.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAllNewOrders extends StatefulWidget {
  ViewAllNewOrders({Key? key}) : super(key: key);

  @override
  State<ViewAllNewOrders> createState() => _ViewAllNewOrdersState();
}

class _ViewAllNewOrdersState extends State<ViewAllNewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All New Orders'),
      body: _list(),
    );
  }

  Widget _list() {
    return RealtimePagination(
      itemsPerPage: 50,
      //item builder type is compulsory.
      itemBuilder: (index, context, documentSnapshot) {
        Map data = documentSnapshot.data() as Map;
        return OrderItem(data: data);
      },
      initialLoading: Center(
        child: CircularProgressIndicator(),
      ),
      emptyDisplay: Center(
        child: Text('No new orders available'),
      ),
      customPaginatedBuilder: (itemcount, controller, itemBuilder) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
          shrinkWrap: true,
          reverse: true,
          itemBuilder: itemBuilder,
          itemCount: itemcount,
          controller: controller,
        );
      },
      // orderBy is compulsory to enable pagination
      query: FirebaseFirestore.instance
          .collection('orders')
          .where('current_store_uid', isEqualTo: ConnectHiveSessionData.getUid)
          .where('order_details.order_status', isEqualTo: '')
          .orderBy('order_details.order_id', descending: true),
    );
  }
}
