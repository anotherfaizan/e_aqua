import 'package:aquatic_vendor_app/app_providers/auth_provider.dart';
import 'package:aquatic_vendor_app/app_providers/order_provider.dart';
import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context) => AuthProvider()),
  ChangeNotifierProvider(create: (context) => PersonalDetailsProvider()),
  ChangeNotifierProvider(create: (context) => PetListProvider()),
  ChangeNotifierProvider(create: (context) => OrderProvider()),
];
