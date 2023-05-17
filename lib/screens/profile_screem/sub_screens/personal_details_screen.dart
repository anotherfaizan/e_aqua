import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_service/app_api_collection.dart';
import 'package:aquatic_vendor_app/app_service/date_time_picker_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/build_textfield.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/submit_button.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late Future _getData;
  Map _details = {};

  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _dob = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _houseAddress = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();

  Map _statCity = {};
  List _cityList = [];

  String? _selectedState;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _getData = _getDetails();
  }

  @override
  void dispose() {
    _fName.dispose();
    _lName.dispose();
    _dob.dispose();
    _mobile.dispose();
    _email.dispose();
    _houseAddress.dispose();
    _state.dispose();
    _city.dispose();
    super.dispose();
  }

  Future _getDetails() async {
    try {
      Map data = await AppApiCollection.getUserDetails();
      _details = data['details'];

      //get state city data from api
      await _getStateCity();

      //set controllers
      _setControllers();
    } catch (e) {}

    return _details;
  }

  void _setControllers() {
    _fName.text = padQuotes(_details['first_name']);
    _lName.text = padQuotes(_details['last_name']);
    _dob.text = padQuotes(_details['date_of_birth']);
    _mobile.text = padQuotes(_details['mobile_number']);
    _email.text = padQuotes(_details['email']);
    _houseAddress.text = padQuotes(_details['address']);
    _selectedState = _details['state'];

    if (_selectedState != null) {
      _cityList = _statCity[_selectedState];
    }
    _selectedCity = _details['city'];
  }

  Future<void> _getStateCity() async {
    _statCity = await AppApiCollection.getStateCity();
    //remove unwanted keys in api response
    _statCity.remove('');
    _statCity.remove('Karnatka');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(ConnectHiveSessionData.getUserPhone());
    changeStatusColor(context, AppColors.backgroundColor);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Personal Details',
          actions: [
            TextButton(
              onPressed: () {},
              child: buildText(
                'Edit',
                fontSize: 16,
                fontColor: AppColors.PrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: _getData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: buildText(
                              'Your BIO',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BuildTextField(
                            controller: _fName,
                            hintText: 'Your first name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your first name required.';
                              }
                              return null;
                            },
                          ),
                          BuildTextField(
                            controller: _lName,
                            hintText: 'Your last name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your last name required.';
                              }
                              return null;
                            },
                          ),
                          BuildTextField(
                            readOnly: true,
                            controller: _dob,
                            hintText: 'Your birthday as 00/00/0000',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your birthday required.';
                              }
                              return null;
                            },
                            onTap: () async {
                              String? date =
                                  await DateTimePickerService.datePicker(
                                context,
                              );

                              if (date != null) {
                                _dob.text = date;
                                setState(() {});
                              }
                            },
                          ),
                          BuildTextField(
                            readOnly: true,
                            controller: _mobile,
                            hintText: 'Your mobile number',
                          ),
                          BuildTextField(
                            controller: _email,
                            hintText: 'Your email id',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your email required.';
                              }
                              return null;
                            },
                          ),
                          BuildTextField(
                            controller: _houseAddress,
                            hintText: 'Your house address',
                            height: 120,
                            contentPadding:
                                const EdgeInsets.only(left: 10, top: 10),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Your house address required.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  isDense: true,
                                  errorStyle: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Your state required.';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        isDense: true,
                                        hintText: 'Select State',
                                        border: InputBorder.none,
                                      ),
                                      value: _selectedState,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          _selectedState = newValue;
                                          _cityList = _statCity[_selectedState];

                                          if (_cityList.isNotEmpty) {
                                            _selectedCity =
                                                _cityList.first['City'];
                                          }

                                          setState(() {});
                                        }
                                      },
                                      items: _statCity.keys
                                          .map((e) => DropdownMenuItem<String>(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList()),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.0),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  isDense: true,
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 16.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        isCollapsed: true,
                                        isDense: true,
                                        hintText: 'Select City',
                                        border: InputBorder.none,
                                      ),
                                      value: _selectedCity,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        _selectedCity = newValue;
                                        setState(() {});
                                      },
                                      items: _cityList
                                          .map((e) => DropdownMenuItem<String>(
                                                value: e['City'],
                                                child: Text(e['City']),
                                              ))
                                          .toList()),
                                ),
                              );
                            },
                          ),
                          Consumer<PersonalDetailsProvider>(
                              builder: (context, provider, _) {
                            return SubmitButton(
                              isLoading: provider.isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // provider.savePersonalDetails(
                                  //   context: context,
                                  //   firstName: _fName.text,
                                  //   lastName: _lName.text,
                                  //   state: _selectedState!,
                                  //   dob: _dob.text,
                                  //   email: _email.text,
                                  //   city: _selectedCity!,
                                  //   address: _houseAddress.text,
                                  //   mobileNumber: _mobile.text,
                                  //   latitude: '',
                                  //   longitude: '',

                                  // );
                                }
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
