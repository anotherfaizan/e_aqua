library utils.connect.hive;

import 'dart:convert';

import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:aquatic_vendor_app/app_models/user_information_model.dart' as uim;

part 'boxes/connect_hive_networkData.dart';
part 'boxes/connect_hive_sessionData.dart';
part 'boxes/connect_hive_settingsData.dart';

class ConnectHive {
  ///* --------------- Box name --------------- *///
  static const String boxNameSessionData = "sessionData";
  static const String boxNameSettingsData = "settingsData";
  static const String boxNameNetworkData = "networkData";

  ///* --------------- initialize Box --------------- *///
  static final Box boxSessionData = Hive.box(boxNameSessionData);
  static final Box boxSettingsData = Hive.box(boxNameSettingsData);
  static final Box boxNetworkData = Hive.box(boxNameNetworkData);
}