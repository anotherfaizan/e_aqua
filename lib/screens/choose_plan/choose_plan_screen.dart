import 'package:aquatic_vendor_app/app_service/app_api_collection.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/choose_plan/widget/plan_card.dart';
import 'package:flutter/material.dart';

class ChoosePlanScreen extends StatefulWidget {
  final bool navBack;
  ChoosePlanScreen({
    Key? key,
    this.navBack = false,
  }) : super(key: key);

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  final PageController controller = PageController(viewportFraction: 0.90);

  late Future _getPlans;

  List _planList = [];

  Future _getAllPlan() async {
    var res = await AppApiCollection.getAllPlans();
    return res;
  }

  @override
  void initState() {
    super.initState();
    _getPlans = _getAllPlan();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(
      context,
      Color.fromRGBO(249, 249, 249, 1),
    );
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(
          context,
          leadingwidth: 0.0,
          backgroundColor: Color.fromRGBO(249, 249, 249, 1),
          title: buildText(
            'Choose your plan',
            fontSize: 27,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Color.fromRGBO(249, 249, 249, 1),
        body: FutureBuilder(
            future: _getPlans,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map data = snapshot.data as Map;
                _planList = data['plans'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 60,
                  ),
                  child: PageView.builder(
                    controller: controller,
                    itemCount: _planList.length,
                    itemBuilder: (context, i) => PlanCard(
                      data: _planList[i],
                      navBack: widget.navBack,
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
