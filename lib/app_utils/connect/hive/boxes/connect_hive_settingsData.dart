part of utils.connect.hive;

class ConnectHiveSettingsData {
  ///* --------------- key --------------- *///
  static const _show_introduction = "show_introduction";

  ///* --------------- function --------------- *///
  /// openBox
  static openBox() async => await Hive.openBox(ConnectHive.boxNameSettingsData);

  /// clear
  static get clear async => await ConnectHive.boxSettingsData.clear();

  /// getter
  static bool? get getShowIntroduction =>
      ConnectHive.boxSettingsData.get(_show_introduction);

  /// setter
  static setShowIntroduction(bool input) =>
      ConnectHive.boxSettingsData.put(_show_introduction, input);
}
