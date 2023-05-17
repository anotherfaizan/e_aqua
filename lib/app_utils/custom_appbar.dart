import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(
  BuildContext context, {
  Widget? title,
  bool? centerTitle,
  double? elevation,
  Color? backgroundColor,
  PreferredSizeWidget? bottom,
  List<Widget>? actions,
  double? toolbarHeight,
  bool? automaticallyImplyLeading,
  double? leadingwidth,
}) {
  final bool? parentRoute = ModalRoute.of(context)?.canPop;
  return AppBar(
    leadingWidth: leadingwidth ?? 65,
    leading: automaticallyImplyLeading == false
        ? SizedBox()
        : (parentRoute == null || parentRoute == false)
            ? SizedBox()
            : Container(
                height: 40,
                width: 60,
                // padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 10, top: 5, bottom: 5, right: 10),
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
    title: title ?? SizedBox(),
    elevation: elevation ?? 0,
    centerTitle: centerTitle ?? true,
    backgroundColor: backgroundColor ?? AppColors.backgroundColor,
    bottom: bottom,
    actions: actions,
    toolbarHeight: toolbarHeight,
    automaticallyImplyLeading: automaticallyImplyLeading ?? true,
  );
}
