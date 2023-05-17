import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/screens/add_new_pet_screen.dart';
import 'package:aquatic_vendor_app/screens/add_product/add_product.dart';
import 'package:flutter/material.dart';

class AddNewPetButton extends StatelessWidget {
  const AddNewPetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.PrimaryColor,
        padding: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        //nav(context, AddNewPetScreen());
        nav(context, AddProduct());
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildText(
            'Add a new product',
            fontSize: 16,
            fontColor: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
