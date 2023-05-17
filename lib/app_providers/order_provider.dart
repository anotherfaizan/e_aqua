import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/repositories/order_reposiory.dart';
import 'package:aquatic_vendor_app/screens/manage_orders/manage_orders_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider extends ChangeNotifier {
  OrderRepository _orderRepository = OrderRepository();
  bool isLoading = false;

  void updateOrder({
    required BuildContext context,
    required String orderId,
    required String storeId,
    required String orderStatus,
    bool navigateToManageOrders = false,
  }) async {
    _isLoading(true);
    try {
      await _orderRepository.updateOrderStatus(
        orderId: orderId,
        storeId: storeId,
        orderStatus: orderStatus,
      );

      //update firebase order status accepted
      FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'order_details.order_status': orderStatus},
      );

      //show snackbar
      SnackBarService.showSnackBar(
        context: context,
        message: 'Order Status Updated to $orderStatus',
      );

      //push replace
      if (navigateToManageOrders) {
        navigationPushReplacement(context, ManageOrdersScreen());
      }
    } catch (e) {
      debugPrint(e.toString());
      SnackBarService.showSnackBar(
        context: context,
        message: 'Something went wrong.',
      );
    }

    _isLoading(false);
  }

  void _isLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
