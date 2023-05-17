import 'dart:io';

import 'package:aquatic_vendor_app/app_service/app_api_collection.dart';
import 'package:aquatic_vendor_app/app_service/file_picker_service.dart';
import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/choose_plan_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/edit_store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/store_details_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/background_stack_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/start_selling.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

class PersonalDetailsProvider extends ChangeNotifier {
  ProfileRepository _profileRepository = ProfileRepository();
  bool isLoading = false;

  File? licenceFile;
  String? pickedLicenceFileName;

  void savePersonalDetails({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String state,
    required String city,
    required dob,
    required String address,
    required String mobileNumber,
    required String latitude,
    required String longitude,
    required dynamic getDetails,
  }) async {
    bool navBack = false;
    _isLoading(true);
    try {
      Map res = await AppApiCollection.editUser(
        firstName: firstName,
        lastName: lastName,
        dob: dob,
        email: email,
        state: state,
        city: city,
        address: address,
        mobileNumber: mobileNumber,
        latitude: '',
        longitude: '',
      );

      if (res.containsKey('successMsg')) {
        if (getDetails != null) {
          navBack = true;
          getDetails();
        }

        Map? userData = ConnectHiveSessionData.getUserData;
        if (userData['first_name'] == null) {
          await setUserdata();
          navigationRemove(context, EditStoreDetail());
        } else {
          await setUserdata();
        }

        SnackBarService.showSnackBar(
          context: context,
          message: 'Details Updated...',
        );

        if (navBack) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading(false);
  }

  void addStoreDetails({
    required MethodType methodType,
    required BuildContext context,
    required String shopName,
    required String contactNumber,
    required String state,
    required String city,
    required String address,
    required String lattitude,
    required String longitude,
    required String licenceNumber,
    dynamic getDetails,
  }) async {
    bool navBack = false;
    _isLoading(true);

    try {
      var res = await _profileRepository.addStoreDetails(
        methodType: methodType,
        shopName: shopName,
        contactNumber: contactNumber,
        state: state,
        city: city,
        address: address,
        lattitude: lattitude,
        longitude: longitude,
        storeLicenceFile: licenceFile,
        licenceNumber: licenceNumber,
      );

      if (getDetails != null) {
        navBack = true;
        getDetails();
      }

      //fetch store data and store it in hive
      await _storeData(context);

      SnackBarService.showSnackBar(
        context: context,
        message: 'Details Updated.',
      );

      if (navBack) {
        Navigator.pop(context);
      }
    } catch (e) {
      SnackBarService.showSnackBar(
        context: context,
        message: 'Somthing went wrong.',
      );
    }

    _isLoading(false);
  }

  void addBankDetails({
    required MethodType methodType,
    required BuildContext context,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
    required String iFSCCode,
    required String bankEmail,
    dynamic getDetails,
  }) async {
    bool navBack = false;
    _isLoading(true);

    try {
      var res = await _profileRepository.addBankDetails(
        methodType: methodType,
        bankName: bankName,
        accountNumber: accountNumber,
        accountHolder: accountHolder,
        iFSCCode: iFSCCode,
        bankEmail: bankEmail,
      );

      if (getDetails != null) {
        navBack = true;
        getDetails();
      }

      SnackBarService.showSnackBar(
        context: context,
        message: 'Details Updated.',
      );

      if (navBack) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
      SnackBarService.showSnackBar(
        context: context,
        message: 'Somthing went wrong.',
      );
    }

    _isLoading(false);
  }

  void pickStoreLicenceFile() async {
    var result = await FilePickerService.pickFile(
      type: FileType.custom,
      allowedExtension: ['pdf', 'doc'],
    );
    if (result != null) {
      licenceFile = File(result.files.single.path!);
      pickedLicenceFileName = result.files.first.name;
      notifyListeners();
    }
  }

  Future<void> _storeData(BuildContext context) async {
    Map? storeData = ConnectHiveSessionData.getStoreData;
    if (storeData == null) {
      var res = await _profileRepository.getStoreDetails();
      ConnectHiveSessionData.setStoreData(res['storeData']);
      navigationRemove(context, ChoosePlanScreen());
    }
  }

  void purchaseFreePlan(BuildContext context, Map data, bool navBack) async {
    _isLoading(true);
    try {
      Map res = await _profileRepository.purchasePlan(
        planId: padQuotes(data['id']),
        planAmount: '0',
      );

      SnackBarService.showSnackBar(
        context: context,
        message: 'Free Plan purchased.',
      );

      if (res.containsKey('sucess')) {
        //nav to dashboard screen

        await setUserdata();

        if (navBack) {
          Navigator.pop(context);
        } else {
          navigationRemove(context, BottomNavigation(index: 0));
        }
      }
    } catch (e) {
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

  void clear() {
    licenceFile = null;
    pickedLicenceFileName = null;
  }
}
