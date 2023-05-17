import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchasePlan extends StatefulWidget {
  final Map data;
  PurchasePlan({Key? key, required this.data}) : super(key: key);

  @override
  State<PurchasePlan> createState() => _PurchasePlanState();
}

class _PurchasePlanState extends State<PurchasePlan> {
  late Razorpay _razorpay;

  late double _finalAmont;

  ProfileRepository _profileRepository = ProfileRepository();

  @override
  void initState() {
    _finalAmont = double.parse(widget.data['cost']);
    _razorpay = Razorpay();

    // handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _openCheckout();

    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_RSsS2ipWSuc5MA',
      'amount': int.parse(_finalAmont.toStringAsFixed(0)) * 100,
      'name': 'A1aquatics',
      'description': '${widget.data['plan_name']} Subcription',
      'timeout': 300,
    };
    _razorpay.open(options);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _purchasePlan();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    SnackBarService.showSnackBar(
      context: context,
      message: 'Purchase failed.',
    );
    // Do something when payment fails
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  Future<void> _purchasePlan() async {
    try {
      Map res = await _profileRepository.purchasePlan(
        planId: padQuotes(widget.data['id']),
        planAmount: _finalAmont.toStringAsFixed(0),
      );

      SnackBarService.showSnackBar(
        context: context,
        message: '${widget.data['plan_name']} Subcription purchased.',
      );

      if (res.containsKey('sucess')) {
        //nav to dashboard screen
        await setUserdata();
        navigationRemove(context, BottomNavigation(index: 0));
      }
    } catch (e) {
      SnackBarService.showSnackBar(
        context: context,
        message: 'Something went wrong.',
      );
    }
  }
}
