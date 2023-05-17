import 'dart:io';

import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';

class ProfileRepository {
  static final ProfileRepository _profileRepo = ProfileRepository._internal();

  factory ProfileRepository() {
    return _profileRepo;
  }
  ProfileRepository._internal();

  //add store details
  Future addStoreDetails({
    required MethodType methodType,
    required String shopName,
    required String contactNumber,
    required String state,
    required String city,
    required String address,
    required String lattitude,
    required String longitude,
    required String licenceNumber,
    File? storeLicenceFile,
  }) async {
    var res = await ConnectApi.uploadSingleFile(
      methodType == MethodType.add ? 'AddStore' : 'UpdateStore',
      uploadFile: storeLicenceFile,
      fileParameter: 'License_Doc',
      body: {
        'Owner_Uid': ConnectHiveSessionData.getUid!,
        'Shop_Name': shopName,
        'Contact_Number': contactNumber,
        'Shop_State': state,
        'Shop_City': city,
        'Shop_Address': address,
        'License_Number': licenceNumber,
        'Latitude': lattitude,
        'Longitude': longitude,
      },
    );
    return res;
  }

  //add store details
  Future addBankDetails({
    required MethodType methodType,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
    required String iFSCCode,
    required String bankEmail,
  }) async {
    var res = await ConnectApi.postCallMethod(
      methodType == MethodType.add ? 'AddBank' : 'UpdateBank',
      body: {
        'Owner_Uid': ConnectHiveSessionData.getUid!,
        'Shop_Id': ConnectHiveSessionData.getStoreId(),
        'Bank_Name': bankName,
        'Account_Number': accountNumber,
        'Account_Holder': accountHolder,
        'IFSC_Code': iFSCCode,
        'Bank_Email': bankEmail,
      },
    );
    return res;
  }

  Future purchasePlan({
    required String planId,
    required String planAmount,
  }) async {
    var res = await ConnectApi.postCallMethod(
      'PurchasePlan',
      body: {
        'Uid': ConnectHiveSessionData.getUid!,
        'Plan_id': planId,
        'Plan_Amount': planAmount,
      },
    );
    return res;
  }

  Future getStoreDetails() async {
    var res = await ConnectApi.postCallMethod(
      'GetStore',
      body: {
        'Owner_Uid': ConnectHiveSessionData.getUid,
      },
    );
    return res;
  }

  Future getBankDetails() async {
    var res = await ConnectApi.postCallMethod(
      'GetBank',
      body: {
        'Owner_Uid': ConnectHiveSessionData.getUid,
      },
    );
    return res;
  }
}
