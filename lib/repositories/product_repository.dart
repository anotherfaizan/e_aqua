import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';

class ProductRepository {
  static final ProductRepository _productRepo = ProductRepository._internal();

  factory ProductRepository() {
    return _productRepo;
  }
  ProductRepository._internal();

  //add product
  Future addProduct({
    required String productId,
  }) async {
    var res = await ConnectApi.postCallMethod(
      'AddVendorProduct',
      body: {
        'Store_Uid': ConnectHiveSessionData.getUid,
        'Product_Id': productId,
      },
    );
    return res;
  }

  //get product by product id
  Future productbyId({
    required String productId,
  }) async {
    var res = await ConnectApi.postCallMethod(
      'GetProducts',
      body: {
        'Product_Ids': productId,
      },
    );
    return res;
  }

  //remove product
  Future removeProduct({
    required String productId,
  }) async {
    var res = await ConnectApi.postCallMethod(
      'RemoveProduct',
      body: {
        'Store_Uid': ConnectHiveSessionData.getUid,
        'Product_Id': productId,
      },
    );
    return res;
  }

  Future getProductCategories() async {
    var res = await ConnectApi.getCallMethod(
      'productCategories',
    );
    return res;
  }

  Future getAllProducts() async {
    var res = await ConnectApi.getCallMethod(
      'GetAllProducts',
    );
    return res;
  }

  Future getVendorAllProducts(int pageIndex) async {
    var res = await ConnectApi.getCallMethod(
      'GetAllProducts/${ConnectHiveSessionData.getUid}?page=$pageIndex',
    );
    return res['data'];
  }

  Future getVendorAllProductsMap() async {
    var res = await ConnectApi.getCallMethod(
      'GetAllProducts/${ConnectHiveSessionData.getUid}',
    );
    return res;
  }
}
