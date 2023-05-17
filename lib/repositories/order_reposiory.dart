import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';

class OrderRepository {
  static final OrderRepository _orderRepo = OrderRepository._internal();

  factory OrderRepository() {
    return _orderRepo;
  }
  OrderRepository._internal();

  //update order status
  Future updateOrderStatus({
    required String orderId,
    required String storeId,
    required String orderStatus,
  }) async {
    var res = await ConnectApi.postCallMethod(
      'UpdateOrderStoreId',
      body: {
        'Order_Id': orderId,
        'Store_Id': storeId,
        'Order_Status': orderStatus,
      },
    );
    return res;
  }

  Future getAllVendorOrders() async {
    var res = await ConnectApi.postCallMethod(
      'Orders',
      body: {
        'Store_Id': ConnectHiveSessionData.getStoreId(),
      },
    );
    return res;
  }
}
