import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/order_reposiory.dart';
import 'package:aquatic_vendor_app/screens/transaction_summary/subscreens/todays_earning_screen.dart';
import 'package:flutter/material.dart';

import 'content/tab_order_list.dart';

class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key? key, this.initialTabIndex}) : super(key: key);
  final int? initialTabIndex;

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final String dropItem = 'Total Earnings';

  final double tabbarTextSize = 14;

  OrderRepository _orderRepository = OrderRepository();

  late Future _getData;

  List _orderList = [];

  @override
  void initState() {
    _getData = _getAllOrders();
    super.initState();
  }

  Future _getAllOrders() async {
    Map res = await _orderRepository.getAllVendorOrders();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, Colors.white);
    return DefaultTabController(
      initialIndex: widget.initialTabIndex ?? 0,
      length: 6,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: customAppBar(
            context,
            title: buildText(
              'Transaction Summary',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 160),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.PrimaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        buildText(
                          '5000',
                          fontColor: AppColors.PrimaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildText(
                                dropItem,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              Container(
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 35,
                                  color: AppColors.PrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: buildText(
                          'Todays Earning',
                          fontColor: AppColors.PrimaryColorDark,
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Tab(
                        child: buildText(
                          'Accepted Orders',
                          fontColor: AppColors.brightGreen,
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Tab(
                        child: buildText(
                          'Packed Orders',
                          fontColor: Colors.red,
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Tab(
                        child: buildText(
                          'Ready To Dispatch Orders',
                          fontColor: Colors.yellow[800],
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Tab(
                        child: buildText(
                          'Out for Delivery Orders',
                          fontColor: Colors.yellow[800],
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Tab(
                        child: buildText(
                          'Successfull Orders',
                          fontColor: Colors.yellow[800],
                          fontSize: tabbarTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: FutureBuilder(
              future: _getData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map data = snapshot.data as Map;

                  _orderList = data['order'];
                  return TabBarView(children: [
                    TodaysEarningsScreen(),
                    TabOrderList(
                      allOrdersList: _orderList,
                      orderStatus: orderStatusString(OrderStatus.Accepted),
                    ),
                    TabOrderList(
                      allOrdersList: _orderList,
                      orderStatus: orderStatusString(OrderStatus.Packed),
                    ),
                    TabOrderList(
                      allOrdersList: _orderList,
                      orderStatus:
                          orderStatusString(OrderStatus.ReadyToDispatch),
                    ),
                    TabOrderList(
                      allOrdersList: _orderList,
                      orderStatus:
                          orderStatusString(OrderStatus.OutForDelivery),
                    ),
                    TabOrderList(
                      allOrdersList: _orderList,
                      orderStatus: 'Successfull Order',
                    ),
                  ]);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
