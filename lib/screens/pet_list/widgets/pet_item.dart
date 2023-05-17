import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetItem extends StatefulWidget {
  final int index;
  final Map data;
  final String groupValue;
  final ValueChanged<String> onSelected;
  const PetItem({
    Key? key,
    required this.index,
    required this.data,
    required this.groupValue,
    required this.onSelected,
  }) : super(key: key);

  
  @override
  State<PetItem> createState() => _PetItemState();
}

class _PetItemState extends State<PetItem> {
  late PetListProvider _petListProvider;

  @override
  void initState() {
    super.initState();
    _petListProvider = Provider.of(context, listen: false);
  }

  //index
  @override
  Widget build(BuildContext context) {
    bool _isSelected = padQuotes(widget.index) == widget.groupValue;
    return GestureDetector(
      onLongPress: () {
        _petListProvider.setSelectedPet(widget.data);
        widget.onSelected(padQuotes(widget.index));
      },
      onTap: () {
        productDetailsNav(context, widget.data);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 100,
        height: 60,
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.PrimaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
          color: _isSelected ? Colors.blue[100] : AppColors.PrimaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  AppConstants.assetImages + 'cat_category.png',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              width: double.infinity,
              child: buildText(
                padQuotes(widget.data['product_name']),
                fontWeight: FontWeight.w600,
                fontSize: 16,
                maxLine: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
