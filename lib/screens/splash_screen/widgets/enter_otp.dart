import 'package:aquatic_vendor_app/app_providers/auth_provider.dart';
import 'package:aquatic_vendor_app/app_resources/time_countdown/countdown.dart';
import 'package:aquatic_vendor_app/app_resources/time_countdown/timer_controller.dart';
import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/choose_plan_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/background_stack_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class EnterOTP extends StatefulWidget {
  const EnterOTP({Key? key}) : super(key: key);

  @override
  State<EnterOTP> createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  final _formKey = GlobalKey<FormState>();
  final _enterOtp = TextEditingController();
  late AuthProvider _authProvider;
  late CountdownController controller;
  bool _showResendotp = false;
  bool _isChecked = false;

  @override
  void initState() {
    _authProvider = Provider.of(context, listen: false);
    controller = CountdownController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.start();
    });
    _listenCode();
    super.initState();
  }

  @override
  void dispose() {
    _enterOtp.dispose();
    super.dispose();
  }

  _listenCode() async {
    await SmsAutoFill().listenForCode();
    SmsAutoFill().code.listen((code) {
      _enterOtp.text = code;

      if (_isChecked) {
        if (_formKey.currentState!.validate()) {
          _authProvider.authenticateWithPhoneNumberOtp(
            context: context,
            smsCode: _enterOtp.text,
          );
          FocusManager.instance.primaryFocus!.unfocus();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundStackScreen(
      screenNo: 3,
      visible: false,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              // width: MediaQuery.of(context).size.width,

              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: _isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked = value!;
                            });
                          }),
                      Flexible(
                        child: Container(
                          child: const Text(
                            'I Accept the ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'terms & conditions',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.lightBlueAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _enterOtp,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 15),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.lock,
                        color: Colors.grey[700],
                      ),
                      hintText: 'Enter OTP',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Enter OTP";
                      } else if (value.toString().characters.length != 6) {
                        return "Enter 6 Digit OTP";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _countdown(),
                      _resendOTP(),
                      SizedBox(
                        width: 10,
                      ),
                      Consumer<AuthProvider>(builder: (context, provider, _) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_isChecked) {
                              if (_formKey.currentState!.validate()) {
                                provider.authenticateWithPhoneNumberOtp(
                                  context: context,
                                  smsCode: _enterOtp.text,
                                );
                                FocusManager.instance.primaryFocus!.unfocus();
                              }
                            }
                            if (_isChecked == false) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: Text(
                                    "Please Accept the Terms & Conditions to continue.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text("Okay"),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // navigationPushReplacement(
                            //     context, ChoosePlanScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 13, horizontal: 10),
                            child: provider.loading
                                ? Center(
                                    child: SizedBox(
                                      height: 18.0,
                                      width: 18.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : buildText(
                                    'Submit',
                                    fontColor: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.PrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countdown() {
    return Visibility(
      visible: !_showResendotp,
      child: Countdown(
        controller: controller,
        seconds: 60,
        build: (BuildContext context, double time) => Text(
          'Resend OTP in ' + time.toStringAsFixed(0) + 's',
        ),
        interval: Duration(milliseconds: 100),
        onFinished: () {
          _showResendotp = true;
          setState(() {});
        },
      ),
    );
  }

  Widget _resendOTP() {
    return Visibility(
      visible: _showResendotp,
      child: TextButton(
        onPressed: () {
          SnackBarService.showSnackBar(
            context: context,
            message: 'OTP is resent.',
          );
          _authProvider.resendOTP(context);
          _showResendotp = false;
          setState(() {});
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            controller.restart();
          });
        },
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
            ),
            children: [
              TextSpan(
                  text: 'Resend ',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              TextSpan(
                text: 'OTP',
                style: TextStyle(
                  color: AppColors.PrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
