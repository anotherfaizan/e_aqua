import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/add_product/content/category_list.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/list_of_pets/list_of_your_pets_screen.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:aquatic_vendor_app/widgets/build_search_bar.dart';
import 'package:aquatic_vendor_app/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'content/search_result.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late PetListProvider _petListProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _petListProvider = Provider.of(context, listen: false);
    _getPetList();
  }

  void _getPetList() async {
    await _petListProvider.getProductCategories();
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select the product to sell',
        actions: [
          Selector<PetListProvider, Tuple2<Map, bool>>(
            selector: (context, provider) => Tuple2(
              provider.selectedPet,
              provider.isLoading,
            ),
            builder: (context, data, _) {
              return data.item1.isNotEmpty
                  ? TextButton(
                      onPressed: () {
                        _petListProvider.addPet(context);
                      },
                      child: data.item2
                          ? SizedBox(
                              height: 18.0,
                              width: 18.0,
                              child: CircularProgressIndicator(),
                            )
                          : buildText(
                              'Done',
                              fontSize: 16,
                              fontColor: AppColors.PrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
      body: !_isLoading ? _content() : _loading(),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          //search bar
          BuildSearchBar(),

          //body
          Selector<PetListProvider, bool>(
            selector: (context, provider) => provider.showSearchResults,
            builder: (context, bool showSearchRes, _) {
              return showSearchRes ? SearchResults() : CategoryList();
            },
          ),
        ],
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
