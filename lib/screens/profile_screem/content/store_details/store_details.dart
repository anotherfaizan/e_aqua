import 'dart:async';
import 'dart:developer';

import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_resources/google_map_location_picker-master/google_map_location_picker.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/personal_details/edit_personal_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/store_details/edit_store_details.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/build_textfield.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/submit_button.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:aquatic_vendor_app/widgets/input/app_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key}) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  final _formKey = GlobalKey<FormState>();

  late PersonalDetailsProvider _personalDetailsProvider;
  ProfileRepository _profileRepository = ProfileRepository();

  final _shopName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _address = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _licenceNumber = TextEditingController();
  StreamController<Map?> _streamController = StreamController<Map?>();

  bool _isLocationSelected = false;

  Map? _storeData;

  @override
  void initState() {
    _personalDetailsProvider = Provider.of(context, listen: false);
    _getDetails();
    super.initState();
  }

  @override
  void dispose() {
    _shopName.dispose();
    _contactNumber.dispose();
    _address.dispose();
    _state.dispose();
    _city.dispose();
    _licenceNumber.dispose();
    _personalDetailsProvider.clear();
    _streamController.close();
    super.dispose();
  }

  void _getDetails() async {
    var res = await _profileRepository.getStoreDetails();
    _storeData = res['storeData'];
    _streamController.add(_storeData);
  }

  void _setController(Map data) {
    if (_storeData != null) {
      _shopName.text = padQuotes(_storeData!['shop_name']);
      _contactNumber.text = padQuotes(_storeData!['contact_number']);
      _address.text = padQuotes(_storeData!['shop_address']);
      _state.text = padQuotes(_storeData!['shop_state']);
      _city.text = padQuotes(_storeData!['shop_city']);

      _licenceNumber.text = padQuotes(_storeData!['license_no']);

      if (_address.text.isNotEmpty) _isLocationSelected = true;

      if (_storeData!['license_doc'] != null) {
        String name = 'Licence_Document';
        _personalDetailsProvider.pickedLicenceFileName =
            name + p.extension(_storeData!['license_doc']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Store Details',
          actions: [
            TextButton(
              onPressed: () {
                nav(
                    context,
                    EditStoreDetail(
                      data: _storeData!,
                      getDetails: _getDetails,
                    ));
              },
              child: buildText(
                'Edit',
                fontSize: 16,
                fontColor: AppColors.PrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map data = snapshot.data as Map;
                _setController(data);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: buildText(
                              'Your Store Details',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BuildTextField(
                            readOnly: true,
                            controller: _shopName,
                            hintText: 'Name of Store',
                            validator: (v) {
                              if (v != null && v.isEmpty) {
                                return "Name of store required.";
                              }

                              return null;
                            },
                          ),
                          BuildTextField(
                            readOnly: true,
                            controller: _contactNumber,
                            hintText: 'Contact Number',
                            validator: (v) {
                              if (v != null && v.isEmpty) {
                                return "Contact Number required.";
                              }

                              return null;
                            },
                          ),
                          Visibility(
                            visible: _isLocationSelected,
                            child: Column(
                              children: [
                                BuildTextField(
                                  readOnly: true,
                                  contentPadding: const EdgeInsets.only(
                                    top: 12,
                                    left: 10,
                                  ),
                                  controller: _address,
                                  hintText: 'Address',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Address required.";
                                    }
                                    return null;
                                  },
                                ),
                                BuildTextField(
                                  controller: _state,
                                  contentPadding: const EdgeInsets.only(
                                    top: 12,
                                    left: 10,
                                  ),
                                  hintText: 'State',
                                  readOnly: true,
                                ),
                                BuildTextField(
                                  controller: _city,
                                  contentPadding: const EdgeInsets.only(
                                    top: 12,
                                    left: 10,
                                  ),
                                  hintText: 'City',
                                  readOnly: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: buildText(
                              'Pet Shop Registration License',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              alignment: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BuildTextField(
                            readOnly: true,
                            controller: _licenceNumber,
                            contentPadding: const EdgeInsets.only(
                              top: 12,
                              left: 10,
                            ),
                            hintText: 'Shop Licence Number',
                            validator: (v) {
                              if (v != null && v.isEmpty) {
                                return 'Shop Licence Number required';
                              }

                              return null;
                            },
                          ),
                          Consumer<PersonalDetailsProvider>(
                              builder: (context, provider, _) {
                            return TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                fillColor: Color.fromRGBO(240, 240, 239, 1),
                                filled: true,
                                hintText: provider.pickedLicenceFileName ??
                                    'Select Files',
                              ),
                              validator: (v) {
                                if (provider.pickedLicenceFileName == null) {
                                  return 'Licence Document required';
                                }

                                return null;
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
