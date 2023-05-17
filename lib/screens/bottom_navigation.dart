import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/screens/home_screen/home_screen.dart';
import 'package:aquatic_vendor_app/screens/list_of_pets/list_of_your_pets_screen.dart';
import 'package:aquatic_vendor_app/screens/notification_screen/notification_screen.dart';
import 'package:aquatic_vendor_app/screens/profile_screem/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation({Key? key, this.index: 0}) : super(key: key);
  int? index;

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final List<Widget> pages = [
    HomeScreen(),
    ListOfYourPetsScreen(),
    ProfileScreen(),
    NotificationScreen(),
  ];
  void initState() {
    super.initState();

    int index = widget.index!;
  }

  void selectPage(int index) {
    setState(() {
      widget.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildActiveIcon(IconData icon) {
      return Container(
        color: Colors.lightBlue[100],
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
              ),
              color: AppColors.PrimaryColor,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
      );
    }

    changeStatusColor(context, AppColors.backgroundColor);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        currentIndex: widget.index ?? 0,
        type: BottomNavigationBarType.shifting,

        onTap: selectPage,
        unselectedItemColor: Colors.black,
        // selectedItemColor: Colors.lightBlueAccent[100],
        unselectedLabelStyle: TextStyle(
          backgroundColor: Colors.white,
        ),
        selectedFontSize: 0,
        selectedLabelStyle: TextStyle(
          backgroundColor: Colors.lightBlue[100],
        ),

        // fixedColor: AppColors.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: CircleAvatar(
              // backgroundColor: Color(0xff5F2600),
              backgroundImage:
                  AssetImage("lib/assets/app_images/a1_logo_home.png"),
            ),
            // activeIcon: buildActiveIcon(Icons.home_outlined),
            // backgroundColor: AppColors.PrimaryColor,
            // icon: Icon(
            //   Icons.home_outlined,
            //   color: Colors.black,
            //   size: 25,
            // ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: buildActiveIcon(Icons.pets),
            icon: Icon(
              Icons.pets,
              color: Colors.black,
              size: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: buildActiveIcon(Icons.account_circle_outlined),
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
              size: 25,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            activeIcon: buildActiveIcon(Icons.notifications),
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
              size: 25,
            ),
            label: '',
          ),
        ],

        // selectedIconTheme: IconThemeData(
        //   color: AppColors.PrimaryColor,
        // ),
      ),
      body: pages[widget.index!],
    );
  }
}
