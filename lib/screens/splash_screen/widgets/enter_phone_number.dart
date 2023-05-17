import 'package:aquatic_vendor_app/app_providers/auth_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/background_stack_screen.dart';
import 'package:aquatic_vendor_app/screens/splash_screen/widgets/enter_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EnterPhoneNumber extends StatefulWidget {
  EnterPhoneNumber({Key? key}) : super(key: key);

  @override
  State<EnterPhoneNumber> createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  final _enterPhone = TextEditingController();
  ScrollController controller = ScrollController();
  late AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _authProvider.clear();
    _enterPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: BackgroundStackScreen(
        screenNo: 2,
        visible: false,
        content: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 40,
              left: 20,
              right: 20,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.grey[300],
              ),
              child: Form(
                key: _formKey,
                child: Stack(
                  children: [
                    TextFormField(
                      controller: _enterPhone,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      scrollPadding: const EdgeInsets.all(20.0),
                      keyboardType: TextInputType.phone,
                      // scrollController: controller,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Enter Phone Number";
                        } else if (value.toString().characters.length != 10) {
                          return "Enter 10 Digit Phone Number";
                        }
                        return null;
                      },
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Consumer<AuthProvider>(
                          builder: (context, provider, _) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.PrimaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            // ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _authProvider.authenticateWithPhoneNumber(
                                context: context,
                                phone: _enterPhone.text,
                              );
                              FocusManager.instance.primaryFocus!.unfocus();
                            }

                            //  navigationPushReplacement(context, EnterOTP());
                          },
                          child: provider.loading
                              ? Center(
                                  child: SizedBox(
                                    height: 18.0,
                                    width: 18.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : buildText(
                                  'Send OTP',
                                  fontColor: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
