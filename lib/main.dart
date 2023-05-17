import 'package:aquatic_vendor_app/app_providers/auth_provider.dart';
import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/screens/notification_screen/notification_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/personal_details/edit_personal_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/edit_store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/profile_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/sub_screens/store_details_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/background_stack_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/start_selling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app_providers/init_provider.dart';
import 'screens/bottom_navigation.dart';
import 'screens/choose_plan/choose_plan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await ConnectHiveSessionData.openBox();
  await ConnectHiveSettingsData.openBox();
  await ConnectHiveNetworkData.openBox();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  late Widget screen;

  @override
  void initState() {
    _checkUserLoggedIn();
    super.initState();
  }

  void _checkUserLoggedIn() {
    String? role = ConnectHiveSessionData.getUid;

    if (role != null) {
      Map userData = ConnectHiveSessionData.getUserData;
      Map? storeData = ConnectHiveSessionData.getStoreData;

      //check if user has filled personal details or not
      if (userData['first_name'] == null) {
        // screen = PersonalDetailsScreen();
        screen = EditPersonalDetail();
      } else if (storeData == null) {
        //screen = StoreDetailsScreen();
        screen = EditStoreDetail();
      } else if (userData['plan_name'] == null) {
        screen = ChoosePlanScreen();
      } else {
        screen = BottomNavigation(index: 0);
      }
    } else {
      //app starting screen
      screen = BackgroundStackScreen(screenNo: 1, content: StartSelling());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColors.PrimaryColor,
          scaffoldBackgroundColor: AppColors.backgroundColor
          ),
      home: screen,
    );
  }
}
