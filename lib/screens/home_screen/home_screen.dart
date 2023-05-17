import 'dart:async';
import 'dart:developer';

import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_resources/firestore_pagination/realtime_pagination.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/hive/connect_hive.dart';
import 'package:aquatic_vendor_app/repositories/order_reposiory.dart';
import 'package:aquatic_vendor_app/repositories/product_repository.dart';
import 'package:aquatic_vendor_app/screens/add_new_pet_screen.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/grid_button.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/new_order_item.dart';
import 'package:aquatic_vendor_app/screens/list_of_pets/list_of_your_pets_screen.dart';
import 'package:aquatic_vendor_app/screens/new_orders_screen.dart';
import 'package:aquatic_vendor_app/screens/transaction_summary/tab_bar_screen.dart';
import 'package:aquatic_vendor_app/screens/view_all_orders/view_all_orders.dart';
import 'package:aquatic_vendor_app/widgets/add_new_pet_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/order_item.dart';
import 'package:flutter_switch/flutter_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OrderRepository _orderRepository = OrderRepository();
  ProductRepository _productRepository = ProductRepository();

  late Future _getData;

  StreamController<Map> _dahsboardStream = StreamController<Map>.broadcast();

  late PetListProvider _petListProvider;

  String _totalPetCount = '0';
  String _newOrderCount = '0';
  bool _switchStatus = false;

  @override
  void initState() {
    _getAllOrders();
    _petListProvider = Provider.of(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _dahsboardStream.close();
    super.dispose();
  }

  void _getAllOrders() async {
    var res = await _orderRepository.getAllVendorOrders();
    var allPet = await _productRepository.getVendorAllProductsMap();
    _totalPetCount = padQuotes(allPet['total']);
    await _newOrderCountData();
    _dahsboardStream.add(res);
  }

  Future<void> _newOrderCountData() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('orders')
        .where('current_store_uid', isEqualTo: ConnectHiveSessionData.getUid)
        .where('order_details.order_status', isEqualTo: '')
        .get();

    _newOrderCount = data.docs.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> gridData = [
      {
        'title': 'New Orders',
        'amount': '50',
        'color': Colors.purple,
        'screen': ViewAllNewOrders(),
      },
      {
        'title': 'Total pets',
        'amount': '50',
        'color': Colors.blue,
        'screen': ListOfYourPetsScreen(),
      },
      {
        'title': 'Accepted orders',
        'amount': '50',
        'color': Colors.blue,
        'screen': TabBarScreen(initialTabIndex: 1),
      },
      {
        'title': 'Packed Orders',
        'amount': '50',
        'color': AppColors.brightGreen,
        'screen': TabBarScreen(initialTabIndex: 2),
      },
      {
        'title': 'Ready To Dispatch',
        'amount': '50',
        'color': Colors.red,
        'screen': TabBarScreen(initialTabIndex: 3),
      },
      {
        'title': 'Out For Delivery',
        'amount': '50',
        'color': Colors.yellow[800],
        'screen': TabBarScreen(initialTabIndex: 4),
      },
    ];
    changeStatusColor(context, Colors.white);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: _dahsboardStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map data = snapshot.data as Map;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AddNewPetButton(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FlutterSwitch(
                              activeColor: Colors.green,
                              inactiveColor: Colors.red,
                              width: 80.0,
                              height: 35.0,
                              valueFontSize: 15.0,
                              toggleSize: 35.0,
                              value: _switchStatus,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  _switchStatus = val;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _switchStatus
                                  ? 'Accepting Orders'
                                  : "Turn on the switch to accept orders",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        BuildGridButtons(
                          gridData: gridData,
                          data: data,
                          totalPetsCount: _totalPetCount,
                          newOrderCount: _newOrderCount,
                        ),
                        SizedBox(height: 20),
                        orderListHeading(),
                        SizedBox(height: 8.0),
                        _orderListFirebase(),
                        SizedBox(height: 10),
                        buildBottomButtom(),
                        //The quick brown fox jumps over the lazy dog
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

  Padding buildBottomButtom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 30),
      child: TextButton(
        onPressed: () {
          nav(context, ViewAllNewOrders());
        },
        child: buildText(
          'View all',
          fontColor: AppColors.PrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget orderListHeading() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'New Orders',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _orderListFirebase() {
  return RealtimePagination(
    itemsPerPage: 10,
    //item builder type is compulsory.
    itemBuilder: (index, context, documentSnapshot) {
      Map data = documentSnapshot.data() as Map;
      return OrderItem(
        data: data,
      );
    },

    customPaginatedBuilder: (itemcount, controller, itemBuilder) {
      return ListView.builder(
        shrinkWrap: true,
        reverse: true,
        itemBuilder: itemBuilder,
        itemCount: itemcount,
        controller: controller,
      );
    },
    // orderBy is compulsory to enable pagination
    query: FirebaseFirestore.instance
        .collection('orders')
        .where('current_store_uid', isEqualTo: ConnectHiveSessionData.getUid)
        .where('order_details.order_status', isEqualTo: '')
        .orderBy('order_details.order_id', descending: true),
  );
}

class BuildGridButtons extends StatefulWidget {
  final Map data;
  final String totalPetsCount;
  final String newOrderCount;
  const BuildGridButtons({
    Key? key,
    required this.gridData,
    required this.data,
    required this.totalPetsCount,
    required this.newOrderCount,
  }) : super(key: key);

  final List<Map<String, dynamic>> gridData;

  @override
  State<BuildGridButtons> createState() => _BuildGridButtonsState();
}

class _BuildGridButtonsState extends State<BuildGridButtons> {
  List _orderList = [];

  @override
  void initState() {
    _orderList = widget.data['order'];
    super.initState();
  }

  String _filterCount(status) {
    int count = 0;
    _orderList.forEach((element) {
      if (element['order_status'] == status) {
        count++;
      }
    });
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: [
        GridButtons(
          title: 'New Order',
          count: widget.newOrderCount,
          color: Colors.purple,
          onPressed: () {
            nav(context, ViewAllNewOrders());
          },
          gridData: widget.gridData,
          i: 1,
        ),
        GridButtons(
          title: 'Total pets',
          count: '2',
          color: Colors.blue,
          onPressed: () {
            nav(context, ListOfYourPetsScreen());
          },
          gridData: widget.gridData,
          i: 1,
        ),
        GridButtons(
          title: 'Accepted',
          count: _filterCount('Accepted'),
          color: Colors.blue,
          onPressed: () {
            nav(context, TabBarScreen(initialTabIndex: 1));
          },
          gridData: widget.gridData,
          i: 1,
        ),
        GridButtons(
          title: 'Packed',
          count: _filterCount('Packed'),
          color: AppColors.brightGreen,
          onPressed: () {
            nav(context, TabBarScreen(initialTabIndex: 2));
          },
          gridData: widget.gridData,
          i: 1,
        ),
        GridButtons(
          title: 'Ready to Dispatch',
          count: _filterCount('Ready to Dispatch'),
          color: Colors.red,
          onPressed: () {
            nav(context, TabBarScreen(initialTabIndex: 3));
          },
          gridData: widget.gridData,
          i: 1,
        ),
        GridButtons(
          title: 'Out for Delivery',
          count: _filterCount('Out for Delivery'),
          color: Colors.yellow[800],
          onPressed: () {
            nav(context, TabBarScreen(initialTabIndex: 4));
          },
          gridData: widget.gridData,
          i: 1,
        ),
      ],
    );
  }
}
