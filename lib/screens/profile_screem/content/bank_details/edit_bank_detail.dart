import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/profile_repository.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/build_textfield.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/widget/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBankDetail extends StatefulWidget {
  final Map? data;
  final dynamic getDetails;

  const EditBankDetail({
    Key? key,
    required this.data,
    this.getDetails,
  }) : super(key: key);

  @override
  State<EditBankDetail> createState() => _EditBankDetailState();
}

class _EditBankDetailState extends State<EditBankDetail> {
  final _formKey = GlobalKey<FormState>();
  late PersonalDetailsProvider _personalDetailsProvider;

  final _bankName = TextEditingController();
  final _branchName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _ifscCode = TextEditingController();
  final _accountHolderName = TextEditingController();
  final _email = TextEditingController();

  Map? _bankData;

  @override
  void initState() {
    super.initState();
    _personalDetailsProvider = Provider.of(context, listen: false);
    _getDetails();
  }

  @override
  void dispose() {
    _bankName.dispose();
    _branchName.dispose();
    _accountNumber.dispose();
    _ifscCode.dispose();
    _accountHolderName.dispose();
    _email.dispose();
    super.dispose();
  }

  void _getDetails() async {
    _bankData = widget.data;
    _setController();
  }

  void _setController() {
    if (_bankData != null) {
      _bankName.text = padQuotes(_bankData!['bank_name']);
      // _branchName.text = padQuotes(_bankData!['branch_name']);
      // dropdownvalue = padQuotes(_bankData!['account_type']);
      _accountNumber.text = padQuotes(_bankData!['account_number']);
      _ifscCode.text = padQuotes(_bankData!['ifsc_code']);
      _accountHolderName.text = padQuotes(_bankData!['account_holder']);
      _email.text = padQuotes(_bankData!['bank_email']);
    }
  }

  void _addUpdateBankDetails() {
    if (_formKey.currentState!.validate()) {
      _personalDetailsProvider.addBankDetails(
        methodType: (_bankData != null && _bankData!['id'] != null)
            ? MethodType.update
            : MethodType.add,
        context: context,
        bankName: _bankName.text,
        accountNumber: _accountNumber.text,
        accountHolder: _accountHolderName.text,
        iFSCCode: _ifscCode.text,
        bankEmail: _email.text,
        getDetails: widget.getDetails,
      );
    }
  }

  String? dropdownvalue;
  var accountType = ['Savings', 'Current'];

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
            'Bank Details',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: Padding(
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: buildText(
                            'Your Bank Details',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        BuildTextField(
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
                          controller: _branchName,
                          hintText: 'Branch Name',
                          validator: (v) {
                            if (v != null && v.isEmpty) {
                              return "Branch Name required.";
                            }

                            return null;
                          },
                        ),
                        BuildTextField(
                          controller: _accountNumber,
                          hintText: 'Bank Account Number',
                          validator: (v) {
                            if (v != null && v.isEmpty) {
                              return "Bank Account Number required.";
                            }

                            return null;
                          },
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: DropdownButton<String>(
                              value: dropdownvalue,
                              hint: Text(
                                'Account Type',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: accountType.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(15),
                              underline: Container(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BuildTextField(
                          controller: _ifscCode,
                          hintText: 'Bank IFSC',
                          validator: (v) {
                            if (v != null && v.isEmpty) {
                              return "Bank IFSC required.";
                            } else if (v.toString().characters.length != 11) {
                              return 'The IFSC is an 11 digit alpha numeric code';
                            }

                            return null;
                          },
                        ),
                        BuildTextField(
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
                Consumer<PersonalDetailsProvider>(
                    builder: (context, provider, _) {
                  return SubmitButton(
                    isLoading: provider.isLoading,
                    onPressed: () {
                      _addUpdateBankDetails();
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
