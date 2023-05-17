import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/list_of_pets/list_of_your_pets_screen.dart';
import 'package:aquatic_vendor_app/widgets/build_search_bar.dart';
import 'package:aquatic_vendor_app/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewPetScreen extends StatefulWidget {
  const AddNewPetScreen({Key? key}) : super(key: key);

  static const List<Map<String, String>> categories = [
    {'image': 'cat_category.png', 'label': 'Cats'},
    {'image': 'dog_category.png', 'label': 'Dogs'},
    {'image': 'monkey_category.png', 'label': 'Monkeys'},
    {'image': 'fish_category.png', 'label': 'Fishes'},
    {'image': 'rabbit_category.png', 'label': 'Rabbits'},
    {'image': 'pegion_category.png', 'label': 'Pegions'},
    {'image': 'start_category.png', 'label': 'Others'},
  ];

  @override
  State<AddNewPetScreen> createState() => _AddNewPetScreenState();
}

class _AddNewPetScreenState extends State<AddNewPetScreen> {
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
      appBar: customAppBar(
        context,
        title: buildText(
          'Select the product to sell',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    BuildSearchBar(),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.builder(
                          itemCount: _petListProvider.productCategories.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            Map data =
                                _petListProvider.productCategories[index];

                            return CategoryItem(
                              index: index,
                              data: data,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  
}
