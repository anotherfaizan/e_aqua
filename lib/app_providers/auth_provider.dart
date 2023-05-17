import 'dart:async';

import 'package:aquatic_vendor_app/app_service/app_api_collection.dart';
import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_firebase_firestore.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/choose_plan_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/personal_details/personal_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/personal_details_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/store_details_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/enter_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aquatic_vendor_app/app_models/user_information_model.dart'
    as uim;
import 'package:flutter/services.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  late String _verificationId;
  String? _phoneNumber;
  bool loading = false;
  SignInBodyType _signInBodyType = SignInBodyType.send_otp;

  FirebaseAuth get firebaseAuth => _firebaseAuth;

  set firebaseAuth(FirebaseAuth value) {
    _firebaseAuth = value;
  }

  UserCredential? get userCredential => _userCredential;

  set userCredential(UserCredential? value) {
    _userCredential = value;
  }

  String? get phoneNumber => _phoneNumber;

  set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  bool get getLoading => loading;

  setLoading(bool value, {bool notify: true}) {
    loading = value;
    callNotifyListeners(notify);
  }

  SignInBodyType get signInBodyType => _signInBodyType;

  setSignInBodyType(SignInBodyType value, {bool notify: true}) {
    _signInBodyType = value;
    callNotifyListeners(notify);
  }

  Future authenticateWithPhoneNumber({
    required BuildContext context,
    required String phone,
  }) async {
    phoneNumber = phone;
    setLoading(true);
    final verificationCompleted = (PhoneAuthCredential credential) async {
      debugPrint("verificationCompleted");
      setLoading(false);
      _signInWithCredential(context, credential);
    };

    final verificationFailed = (FirebaseAuthException e) {
      debugPrint("verificationFailed");
      setLoading(false);
      debugPrint(e.toString());
      String errorMessage = "";
      if (e.code == 'invalid-phone-number') {
        errorMessage = "invalid-phone-number";
      } else if (e.code == 'too-many-requests') {
        errorMessage =
            "Blocked this device due to unusual activity. Try again later";
      }
      debugPrint(errorMessage);
      showAppSnackBar(context, errorMessage);
    };

    final codeSent = (String verificationId, int? resendToken) async {
      debugPrint("codeSent");
      setLoading(false);
      debugPrint(verificationId.toString());
      _verificationId = verificationId;
      // setSignInBodyType(SignInBodyType.verify_otp);
      nav(context, EnterOTP());
    };

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91' + _phoneNumber!,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint("codeAutoRetrievalTimeout");
          setLoading(false);
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      debugPrint(e.toString());
      showAppSnackBar(context, e.message);
    }
  }

  Future authenticateWithPhoneNumberOtp({
    required BuildContext context,
    required String smsCode,
  }) async {
    setLoading(true);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      _userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _navigation(context);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showAppSnackBar(
        context,
        'Verification code is invalid',
      );
    }
    setLoading(false);
  }

  void resendOTP(BuildContext context) async {
    // ignore: prefer_function_declarations_over_variables

    final verificationCompleted = (PhoneAuthCredential credential) async {
      _signInWithCredential(context, credential);
    };

    // ignore: prefer_function_declarations_over_variables
    final verificationFailed = (FirebaseAuthException e) {
      debugPrint(e.toString());
      String errorMessage = "";
      if (e.code == 'invalid-phone-number') {
        errorMessage = "Phone number is invalid !";
      } else if (e.code == 'too-many-requests') {
        errorMessage =
            "Blocked this device due to unusual activity. Try again later";
      }
      debugPrint(errorMessage);
      SnackBarService.showSnackBar(context: context, message: errorMessage);
    };

    // ignore: prefer_function_declarations_over_variables
    final codeSent = (String verificationId, int? resendToken) async {
      _verificationId = verificationId;
    };

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91' + _phoneNumber!,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  _signInWithCredential(
    BuildContext context,
    AuthCredential credential,
  ) async {
    try {
      _userCredential = await _firebaseAuth.signInWithCredential(credential);
      // await _navigation(context);

    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showAppSnackBar(
        context,
        'Verification code is invalid',
      );
    }
  }

  Future<void> _navigation(BuildContext context) async {
    if (_userCredential?.user != null) {
      var _userResponse = await ConnectFirebaseFirestore.getUserDetailsFuture(
          userId: _userCredential?.user?.uid);

      /// login
      if (_userResponse.exists) {
        uim.UserInformationModel _userInformationModel =
            uim.UserInformationModel.fromJson(
                _userResponse.data() as Map<String, dynamic>?);

        /// send data to backend
        if (_userInformationModel.userRole == '1') {
          await _sendDataToBackendAndNavigate(
              _userInformationModel, _userResponse, context);
        } else {
          showAppSnackBar(
            context,
            'This account is registered as a user, try to login as Vendor.',
          );
          return;
        }
      }

      /// register
      else {
        var data = uim.UserInformationModel(
          userUid: padQuotes(userCredential?.user?.uid),
          userFirstName: userCredential?.user?.displayName,
          userEmail: userCredential?.user?.email,
          userPhoneNumber: userCredential?.user?.phoneNumber,
          userAuthType: AuthType.phone,
          userRole: "1",
        ).toJson();

        await ConnectFirebaseFirestore.updateUser(
          userId: userCredential!.user!.uid,
          userDetails: data,
        );
        var _uid = userCredential?.user?.uid;

        var _userResponse =
            await ConnectFirebaseFirestore.getUserDetailsFuture(userId: _uid);
        uim.UserInformationModel _userInformationModel =
            uim.UserInformationModel.fromJson(
                _userResponse.data() as Map<String, dynamic>?);

        /// send data to backend
        await _sendDataToBackendAndNavigate(
            _userInformationModel, _userResponse, context);
      }
    }
  }

  Future<void> _sendDataToBackendAndNavigate(
      uim.UserInformationModel _userInformationModel,
      DocumentSnapshot<Object?> _userResponse,
      BuildContext context) async {
    try {
      var _checkAuthResponse = await AppApiCollection.checkAuth(
        uid: _userInformationModel.userUid,
        role: _userInformationModel.userRole,
        authType: _userInformationModel.userAuthType?.name,
        firstName: _userInformationModel.userFirstName,
        lastName: _userInformationModel.userLastName,
        email: _userInformationModel.userEmail,
        phoneNumber: _userInformationModel.userPhoneNumber,
        dateOfBirth: _userInformationModel.userDateOfBirth,
        creationUtcDateTime:
            _userCredential?.user?.metadata.creationTime?.toUtc(),
      );

      if (_checkAuthResponse != null) {
        /// save to hive
        ConnectHiveSessionData.setUid(_userCredential?.user?.uid);
        ConnectHiveSessionData.setUserInformation(
          _userResponse.data() as Map<String, dynamic>?,
        );

        debugPrint(_checkAuthResponse.toString());

        await setUserdata();
        await setStoreData();
        _userNavigation(context);
      } else {
        showAppSnackBar(
          context,
          "something went wrong, please try after some time",
        );
      }
    } catch (e) {
      debugPrint("${e.toString()}");
      showAppSnackBar(
        context,
        "something went wrong, please try after some time",
      );
    }
  }

  callNotifyListeners(bool notify) {
    if (notify) {
      notifyListeners();
    }
  }

  clear() {
    _userCredential = null;
    _phoneNumber = null;
    loading = false;
    _signInBodyType = SignInBodyType.send_otp;
  }

  void _userNavigation(context) {
    Map userData = ConnectHiveSessionData.getUserData;
    Map? storeData = ConnectHiveSessionData.getStoreData;

    if (userData['first_name'] == null) {
      //navigationRemove(context, PersonalDetailsScreen());
      navigationRemove(context, PersonalDetails());
    } else if (storeData == null) {
      //navigationRemove(context, StoreDetailsScreen());
      navigationRemove(context, StoreDetail());
    } else if (userData['plan_name'] == null) {
      navigationRemove(context, ChoosePlanScreen());
    } else {
      navigationRemove(context, BottomNavigation(index: 0));
    }
  }
}
