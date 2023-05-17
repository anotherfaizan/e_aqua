import 'dart:developer';

import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_resources/google_map_location_picker-master/google_map_location_picker.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/build_textfield.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/submit_button.dart';
import 'package:aquatic_vendor_app/widgets/input/app_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

class StoreDetailsScreen extends StatefulWidget {
  const StoreDetailsScreen({Key? key}) : super(key: key);

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late PersonalDetailsProvider _personalDetailsProvider;
  ProfileRepository _profileRepository = ProfileRepository();

  final _shopName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _address = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _licenceNumber = TextEditingController();

  String? _latitude;
  String? _longitude;

  bool _isLocationSelected = false;

  late Future _getData;
  Map? _storeData;

  @override
  void initState() {
    _personalDetailsProvider = Provider.of(context, listen: false);
    _getData = _getDetails();
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
    super.dispose();
  }

  Future _getDetails() async {
    var res = await _profileRepository.getStoreDetails();
    _storeData = res['storeData'];
    _setController();
    return res;
  }

  void _setController() {
    if (_storeData != null) {
      _shopName.text = padQuotes(_storeData!['shop_name']);
      _contactNumber.text = padQuotes(_storeData!['contact_number']);
      _address.text = padQuotes(_storeData!['shop_address']);
      _state.text = padQuotes(_storeData!['shop_state']);
      _city.text = padQuotes(_storeData!['shop_city']);
      _latitude = _storeData!['latitude'];
      _longitude = _storeData!['longitude'];
      _licenceNumber.text = padQuotes(_storeData!['license_no']);

      if (_address.text.isNotEmpty) _isLocationSelected = true;

      if (_storeData!['license_doc'] != null) {
        String name = 'Licence_Document';
        _personalDetailsProvider.pickedLicenceFileName =
            name + p.extension(_storeData!['license_doc']);
      }
    }
  }

  Future<void> _selectUpdateLocation() async {
    LocationResult? result = await showLocationPicker(
      context,
      AppConstants.googleMapKey,
      initialLocation: LatLng(31.1975844, 29.9598339),
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,
      requiredGPS: true,
      desiredAccuracy: LocationAccuracy.best,
    );
    log("result = $result");

    if (result != null) {
      _address.text = result.address!;
      _state.text = result.placemark!.administrativeArea!;
      _city.text = result.placemark!.subAdministrativeArea!;
      _latitude = result.latLng!.latitude.toString();
      _longitude = result.latLng!.longitude.toString();
      _isLocationSelected = true;

      setState(() {});
    }
  }

  void _addUpdateDetails() {
    if (_formKey.currentState!.validate()) {
      _personalDetailsProvider.addStoreDetails(
        context: context,
        methodType: (_storeData != null && _storeData!['id'] != null)
            ? MethodType.update
            : MethodType.add,
        shopName: _shopName.text,
        contactNumber: _contactNumber.text,
        state: _state.text,
        city: _city.text,
        address: _address.text,
        licenceNumber: _licenceNumber.text,
        lattitude: _latitude!,
        longitude: _longitude!,
      );
    } else {
      debugPrint('Form validation Error !');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: buildText(
            'Store Details',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: FutureBuilder(
            future: _getData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                debugPrint(snapshot.data.toString());
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
                            controller: _contactNumber,
                            hintText: 'Contact Number',
                            validator: (v) {
                              if (v != null && v.isEmpty) {
                                return "Contact Number required.";
                              }

                              return null;
                            },
                          ),
                          FormField(
                            initialValue: _isLocationSelected,
                            builder: (state) {
                              debugPrint(state.value.toString());
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppButton(
                                    title: _isLocationSelected
                                        ? 'Update Location'
                                        : 'Select Location',
                                    width: double.infinity,
                                    onPressed: () {
                                      _selectUpdateLocation();
                                    },
                                  ),
                                  state.hasError
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 8.0),
                                          child: Text(
                                            state.errorText!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .button!
                                                .copyWith(color: Colors.red),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              );
                            },
                            validator: (value) {
                              if (_isLocationSelected == false) {
                                return 'Select Location*';
                              }
                              return null;
                            },
                          ),
                          Visibility(
                            visible: _isLocationSelected,
                            child: Column(
                              children: [
                                BuildTextField(
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[700],
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  _personalDetailsProvider
                                      .pickStoreLicenceFile();
                                },
                                child: buildText(
                                  'Pick File',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Consumer<PersonalDetailsProvider>(
                              builder: (context, provider, _) {
                            return Center(
                              child: SubmitButton(
                                isLoading: provider.isLoading,
                                onPressed: () {
                                  _addUpdateDetails();
                                },
                              ),
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
