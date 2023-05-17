import 'package:aquatic_vendor_app/app_providers/personal_details_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/purchase_plan.dart';
import 'package:aquatic_vendor_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlanCard extends StatefulWidget {
  const PlanCard({
    Key? key,
    required this.data,
    required this.navBack,
  }) : super(key: key);

  final Map data;
  final bool navBack;

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  String _planName = '';
  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    Map data = ConnectHiveSessionData.getUserData;
    debugPrint('user s' + data.toString());
    _planName = padQuotes(data['plan_name']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 5,
            color: AppColors.PrimaryColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            buildText(
              padQuotes(widget.data['plan_name']),
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
            SizedBox(
              height: 25,
            ),
            Visibility(
              visible: padQuotes(widget.data['plan_name']) != 'Free',
              child: buildText(
                padQuotes(widget.data['cost']) + ' /month',
                fontSize: 27,
                fontColor: Colors.yellow[700],
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  _benifitTile(widget.data['point_1']),
                  _benifitTile(widget.data['point_2']),
                  _benifitTile(widget.data['point_3']),
                  _benifitTile(widget.data['point_4']),
                  _benifitTile(widget.data['point_5']),
                  _benifitTile(widget.data['point_6']),
                  _benifitTile(widget.data['point_7']),
                  _benifitTile(widget.data['point_8']),
                  _benifitTile(widget.data['point_9']),
                  _benifitTile(widget.data['point_10']),
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _planName == widget.data['plan_name']
                ? buildText(
                    'Current Plan',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )
                : Consumer<PersonalDetailsProvider>(
                    builder: (context, provider, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        primary: AppColors.PrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        _nav(provider);
                      },
                      child: provider.isLoading
                          ? SizedBox(
                              height: 18.0,
                              width: 18.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : buildText(
                              'Select',
                              fontColor: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                    );
                  }),
          ],
        ),
      ),
    );
  }

  Widget _benifitTile(String? benefit) {
    return Visibility(
      visible: benefit != null ? true : false,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.PrimaryColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(1),
                child: Text(
                  benefit ?? '',
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nav(PersonalDetailsProvider provider) {
    if (widget.data['plan_name'] == 'Free') {
      provider.purchaseFreePlan(context, widget.data, widget.navBack);
    } else {
      nav(context, PurchasePlan(data: widget.data));
    }
  }
}
