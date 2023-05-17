import 'dart:async';

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

import 'edit_personal_details.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final _formKey = GlobalKey<FormState>();
  StreamController<Map> _streamController = StreamController<Map>();

  Map _details = {};

  final _fName = TextEditingController();
  final _lName = TextEditingController();
  final _dob = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _houseAddress = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDetails();
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
    _streamController.close();
    super.dispose();
  }

  Future _getDetails() async {
    try {
      Map data = await AppApiCollection.getUserDetails();
      _details = data['details'];
      _streamController.add(_details);
      debugPrint('stream called');
    } catch (e) {}

    return _details;
  }

  void _setControllers(Map data) {
    _fName.text = padQuotes(_details['first_name']);
    _lName.text = padQuotes(_details['last_name']);
    _dob.text = padQuotes(_details['date_of_birth']);
    _mobile.text = padQuotes(_details['mobile_number']);
    _email.text = padQuotes(_details['email']);
    _houseAddress.text = padQuotes(_details['address']);
    _state.text = padQuotes(_details['state']);
    _city.text = padQuotes(_details['city']);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, AppColors.backgroundColor);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Personal Details',
        actions: [
          TextButton(
            onPressed: () {
              nav(
                  context,
                  EditPersonalDetail(
                    data: _details,
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
              _setControllers(data);
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          readOnly: true,
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
                          readOnly: true,
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
                          onTap: () async {},
                        ),
                        BuildTextField(
                          readOnly: true,
                          controller: _mobile,
                          hintText: 'Your mobile number',
                        ),
                        BuildTextField(
                          readOnly: true,
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
                          readOnly: true,
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
                        BuildTextField(
                          readOnly: true,
                          controller: _state,
                          hintText: 'State',
                          height: 120,
                          contentPadding:
                              const EdgeInsets.only(left: 10, top: 10),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                        SizedBox(height: 8.0),
                        BuildTextField(
                          readOnly: true,
                          controller: _city,
                          hintText: 'City',
                          height: 120,
                          contentPadding:
                              const EdgeInsets.only(left: 10, top: 10),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                        ),
                        SizedBox(height: 16.0),
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
    );
  }
}
