part of utils.connect.hive;

class ConnectHiveSessionData {
  ///* --------------- key --------------- *///
  static const _uid = "uid";
  static const _userInformation = "userInformation";
  static const _userData = 'userData';

  static const _storeData = 'storeData';

  ///* --------------- function --------------- *///
  /// openBox
  static openBox() async => await Hive.openBox(ConnectHive.boxNameSessionData);

  /// clear
  static get clear async => await ConnectHive.boxSessionData.clear();

  /// getter
  static String? get getUid => ConnectHive.boxSessionData.get(_uid);

  static String getStoreId() {
    Map data = ConnectHive.boxSessionData.get('storeData');
    return padQuotes(data['id']);
  }

  static String getUserPhone() {
    Map data = ConnectHive.boxSessionData.get(_userData);
    return data['mobile_number'];
  }

  static uim.UserInformationModel get getUserInformation =>
      uim.UserInformationModel.fromJson(json.decode(
          json.encode(ConnectHive.boxSessionData.get(_userInformation))));

  static Map get getUserData => ConnectHive.boxSessionData.get(_userData) ?? {};

  static Map? get getStoreData => ConnectHive.boxSessionData.get(_storeData);

  /// setter
  static setUid(input) => ConnectHive.boxSessionData.put(_uid, input);

  static setUserInformation(input) =>
      ConnectHive.boxSessionData.put(_userInformation, input);

  static setUserData(input) => ConnectHive.boxSessionData.put(_userData, input);

  /// setter
  static setStoreData(input) =>
      ConnectHive.boxSessionData.put(_storeData, input);
}
