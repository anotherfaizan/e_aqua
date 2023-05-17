part of utils.connect.hive;

class ConnectHiveNetworkData {
  ///* --------------- key --------------- *///
  static const _galleryDetails = "Player_Details";

  ///* --------------- function --------------- *///
  /// openBox
  static openBox() async => await Hive.openBox(ConnectHive.boxNameNetworkData);

  /// clear
  static get clear async => await ConnectHive.boxNetworkData.clear();

  /// watch
  /// getter
  /// setter
}