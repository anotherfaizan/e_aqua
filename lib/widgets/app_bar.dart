import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  CustomAppBar({
    this.title,
    this.actions,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 65,
      leading: Container(
        height: 40,
        width: 60,
        // padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 3,
            color: Colors.black,
          ),
          color: Colors.white,
        ),
        child: FittedBox(
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                navigationPop(context);
              },
            ),
          ),
        ),
      ),
      title: buildText(
        title ?? '',
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      actions: actions,
    );
  }
}
