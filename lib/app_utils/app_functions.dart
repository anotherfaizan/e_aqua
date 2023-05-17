import 'package:aquatic_vendor_app/app_service/app_api_collection.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/product_detail/content/aquarium_detail.dart';
import 'package:aquatic_vendor_app/screens/product_detail/content/equipment_detail.dart';
import 'package:aquatic_vendor_app/screens/product_detail/content/food_detail.dart';
import 'package:aquatic_vendor_app/screens/product_detail/content/live_product_detail.dart';
import 'package:aquatic_vendor_app/screens/product_detail/content/service_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:intl/intl.dart';

import 'app_enums.dart';

void nav(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
}

void navigationPushReplacement(BuildContext context, Widget screen) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));
}

void navigationPop(BuildContext context) {
  Navigator.of(context).pop();
}

void navigationRemove(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
    (route) => false,
  );
}

changeStatusColor(context, [Color? color]) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color!, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
      useWhiteForeground(color),
    );
  } on Exception catch (e) {
    print(e);
  }
}

showAppSnackBar(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message!),
      duration: Duration(seconds: 2),
    ),
  );
}

String padQuotes(input) {
  if (input == null || input.toString() == "null") {
    return "";
  } else {
    return input.toString().trim();
  }
}

bool isValidEmail(input) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (regex.hasMatch(input.toString().trim()));
}

Future<void> setUserdata() async {
  Map? res = await AppApiCollection.getUserDetails();
  if (res != null) {
    ConnectHiveSessionData.setUserData(res['details']);
  }
}

Future<void> setStoreData() async {
  ProfileRepository profileRepository = ProfileRepository();
  var res = await profileRepository.getStoreDetails();
  ConnectHiveSessionData.setStoreData(res['storeData']);
}

void productDetailsNav(BuildContext context, Map data) {
  dynamic screen;

  switch (data['product_type']) {
    case 'Live product':
      screen = LiveProductDetail(data: data);
      break;
    case 'Food':
      screen = FoodDetail(data: data);
      break;
    case 'AQUARIUM':
      screen = AquariumDetail(data: data);
      break;
    case 'Equipment':
      screen = EquipmentDetail(data: data);
      break;
    case 'Service booking':
      screen = ServiceBookingDetail(data: data);
      break;
    default:
  }

  if (screen != null) nav(context, screen);
}

String orderStatusString(OrderStatus orderStatus) {
  String status = '';

  switch (orderStatus) {
    case OrderStatus.Accepted:
      status = 'Accepted';
      break;
    case OrderStatus.Packed:
      status = 'Packed';
      break;
    case OrderStatus.ReadyToDispatch:
      status = 'Ready to Dispatch';
      break;
    case OrderStatus.OutForDelivery:
      status = 'Out for Delivery';
      break;
    default:
  }

  return status;
}

String formatedDate({required String date, required AppDateFormat format}) {
  var inputFormat;

  var outputFormat;
  var outputDate;

  switch (format) {
    case AppDateFormat.yyyyMMddTHHmmssSSSZ:
      inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      break;
    case AppDateFormat.yyyymmddHHmmss:
      inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      break;
    default:
      inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  }

  var inputDate = inputFormat.parse(date);

  switch (format) {
    case AppDateFormat.yyyyMMddTHHmmssSSSZ:
      outputFormat = DateFormat('dd/MM/yyyy');
      outputDate = outputFormat.format(inputDate);
      break;
    case AppDateFormat.yyyymmddHHmmss:
      outputFormat = DateFormat('dd/MM/yyyy');
      outputDate = outputFormat.format(inputDate);
      break;

    default:
  }

  return outputDate;
}

void updateOrderStatusInFirebase({
  required String orderId,
  required String orderStatus,
}) {
  FirebaseFirestore.instance.collection('orders').doc(orderId).update(
    {'order_details.order_status': orderStatus},
  );
}
