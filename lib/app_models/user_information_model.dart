import 'dart:convert';

import 'package:aquatic_vendor_app/app_utils/app_enums.dart';

UserInformationModel userInformationModelFromJson(String str) =>
    UserInformationModel.fromJson(json.decode(str));

String userInformationModelToJson(UserInformationModel data) =>
    json.encode(data.toJson());

class UserInformationModel {
  UserInformationModel({
    this.userUid,
    this.userRole,
    this.userFirstName,
    this.userLastName,
    this.userDateOfBirth,
    this.userEmail,
    this.userPhoneNumber,
    this.userImage,
    this.userAuthType,
  });

  String? userUid;
  dynamic userRole;
  String? userFirstName;
  String? userLastName;
  String? userDateOfBirth;
  String? userEmail;
  String? userPhoneNumber;
  String? userImage;
  AuthType? userAuthType;

  factory UserInformationModel.fromJson(Map<String, dynamic>? json) =>
      UserInformationModel(
        userUid: json?["user_uid"],
        userRole: json?["user_role"],
        userFirstName: json?["user_first_name"],
        userLastName: json?["user_last_name"],
        userDateOfBirth: json?["user_date_of_birth"],
        userEmail: json?["user_email"],
        userPhoneNumber: json?["user_phone_number"],
        userImage: json?["user_image"],
        userAuthType: AuthType.values.asNameMap()[json?["user_auth_type"]],
      );

  Map<String, dynamic> toJson() => {
        "user_uid": userUid,
        "user_role": userRole,
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "user_date_of_birth": userDateOfBirth,
        "user_email": userEmail,
        "user_phone_number": userPhoneNumber,
        "user_image": userImage,
        "user_auth_type": userAuthType?.name,
      };
}
