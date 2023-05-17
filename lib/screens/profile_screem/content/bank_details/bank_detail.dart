import 'dart:async';

import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/content/bank_details/edit_bank_detail.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/build_textfield.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/submit_button.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankDetail extends StatefulWidget {
  const BankDetail({Key? key}) : super(key: key);

  @override
  State<BankDetail> createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
  final _formKey = GlobalKey<FormState>();
  ProfileRepository _profileRepository = ProfileRepository();

  StreamController<Map?> _streamController = StreamController<Map?>();

  final _bankName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _ifscCode = TextEditingController();
  final _accountHolderName = TextEditingController();
  final _email = TextEditingController();

  Map? _bankData;

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  void dispose() {
    _bankName.dispose();
    _accountNumber.dispose();
    _ifscCode.dispose();
    _accountHolderName.dispose();
    _email.dispose();
    _streamController.close();
    super.dispose();
  }

  void _getDetails() async {
    var res = await _profileRepository.getBankDetails();
    _bankData = res['bankData'];
    _streamController.add(_bankData ?? {});
  }

  void _setController() {
    if (_bankData != null) {
      _bankName.text = padQuotes(_bankData!['bank_name']);
      _accountNumber.text = padQuotes(_bankData!['account_number']);
      _ifscCode.text = padQuotes(_bankData!['ifsc_code']);
      _accountHolderName.text = padQuotes(_bankData!['account_holder']);
      _email.text = padQuotes(_bankData!['bank_email']);
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
          title: 'Bank Details',
          actions: [
            TextButton(
              onPressed: () {
                nav(
                    context,
                    EditBankDetail(
                      data: _bankData,
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
                _setController();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: buildText(
                                    'Your Bank Details',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                BuildTextField(
                                  readOnly: true,
                                  controller: _bankName,
                                  hintText: 'Bank Name',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Bank Name required.";
                                    }

                                    return null;
                                  },
                                ),
                                BuildTextField(
                                  readOnly: true,
                                  controller: _accountNumber,
                                  hintText: 'Bank Account Number',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Bank Account Number required.";
                                    }

                                    return null;
                                  },
                                ),
                                BuildTextField(
                                  readOnly: true,
                                  controller: _ifscCode,
                                  hintText: 'Bank IFSC',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Bank IFSC required.";
                                    } else if (v.toString().characters.length !=
                                        11) {
                                      return 'The IFSC is an 11 digit alpha numeric code';
                                    }

                                    return null;
                                  },
                                ),
                                BuildTextField(
                                  readOnly: true,
                                  controller: _accountHolderName,
                                  hintText: 'Account Holder\'s Name',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Account Holder\'s Name required.";
                                    }

                                    return null;
                                  },
                                ),
                                BuildTextField(
                                  readOnly: true,
                                  controller: _email,
                                  hintText: 'Email Id',
                                  validator: (v) {
                                    if (v != null && v.isEmpty) {
                                      return "Email Id required.";
                                    } else if (!isValidEmail(v)) {
                                      return 'Email is invalid';
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
