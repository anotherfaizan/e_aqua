import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:aquatic_vendor_app/app_models/user_information_model.dart'
    as uim;

class ConnectFirebaseFirestore {
  /// collections
  static CollectionReference _collectionUsers =
      FirebaseFirestore.instance.collection("users");

  static Future<bool?> isUserExist({required String? userId}) async {
    return await _collectionUsers.doc(userId).get().then((snapshot) async {
      if (snapshot.exists) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    });
  }

  static Future<DocumentSnapshot<Object?>> getUserDetailsFuture(
      {required String? userId}) async {
    return await _collectionUsers.doc("$userId").get();
  }

  static createUser({
    required uim.UserInformationModel? userInformationModel,
  }) async {
    debugPrint("createUser");
    return await _collectionUsers
        .doc(userInformationModel?.userUid)
        .set(userInformationModel?.toJson());
  }

  static updateUser({
    required String? userId,
    required Map<String, dynamic> userDetails,
  }) async {
    bool? result = await isUserExist(userId: userId);
    if (result == true) {
      return await _collectionUsers.doc(userId).update(userDetails);
    }
    return await createUser(
      userInformationModel: uim.UserInformationModel.fromJson(userDetails),
    );
  }
}
