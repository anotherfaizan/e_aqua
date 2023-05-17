import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:intl/intl.dart';

class AppApiCollection {
  static Future checkAuth({
    String? uid,
    dynamic role,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? authType,
    DateTime? creationUtcDateTime,
    DateTime? signedInUtcDateTime,
  }) async {
    var res = await ConnectApi.postCallMethod(
      "checkAuth",
      body: {
        "Uid": uid,
        "Role": role,
        "First_Name": firstName,
        "Last_Name": lastName,
        "Email": email,
        "Mobile_Number": phoneNumber,
        "Date_Of_Birth": dateOfBirth,
        "Auth_Type": authType,
        if (creationUtcDateTime != null)
          "Creation_Date":
              DateFormat("yyyy-MM-dd hh:mm:ss").format(creationUtcDateTime),
        "Last_Login": DateFormat("yyyy-MM-dd hh:mm:ss")
            .format(signedInUtcDateTime ?? DateTime.now().toUtc()),
      },
    );
    return res;
  }

  static Future editUser({
    required String firstName,
    required String lastName,
    String? email,
    required String state,
    required String city,
    String? dob,
    required String address,
    required String mobileNumber,
    required String latitude,
    required String longitude,
  }) async {
    var res = await ConnectApi.postCallMethod(
      "EditUser",
      body: {
        "Uid": ConnectHiveSessionData.getUid,
        "role": '1',
        "First_Name": firstName,
        "Last_Name": lastName,
        "Email": email,
        "State": state,
        "City": city,
        "Date_Of_Birth": dob,
        "Address": address,
        "Mobile_Number": mobileNumber,
        "Latitude": latitude,
        "Longitude": longitude,
      },
    );
    return res;
  }

  static Future getAllPlans() async {
    var res = await ConnectApi.getCallMethod('GetPlans');
    return res;
  }

  static Future getUserDetails() async {
    var res = await ConnectApi.postCallMethod(
      'User',
      body: {
        'Uid': ConnectHiveSessionData.getUid,
        'role': '1',
      },
    );
    return res;
  }

  static Future getStateCity() async {
    var res = await ConnectApi.getCallMethod(
      '',
      useCustomURL: 'https://apisintegration.com/places/api/getStateCity',
    );
    return res;
  }
}
