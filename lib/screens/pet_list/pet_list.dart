import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/screens/bottom_navigation.dart';
import 'package:aquatic_vendor_app/screens/pet_list/widgets/pet_item.dart';
import 'package:aquatic_vendor_app/widgets/build_search_bar.dart';
import 'package:aquatic_vendor_app/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetList extends StatefulWidget {
  final Map data;
  const PetList({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<PetList> createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  late PetListProvider _petListProvider;
  bool _isLoading = true;

  List pets = [];

  String _selectedPet = '';

  List _subcategories = [];

  @override
  void initState() {
    super.initState();
    _petListProvider = Provider.of(context, listen: false);
    _getData();
  }

  void _getData() async {
    _getSubCategories();
    await _getPetByCategory();

    _isLoading = false;
    setState(() {});
  }

  void _getSubCategories() {
    _subcategories = _petListProvider.getSubCategories(
      padQuotes(widget.data['id']),
    );
  }

  Future<void> _getPetByCategory() async {
    pets = await _petListProvider.productsByCategoryId(
      padQuotes(widget.data['id']),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context,
          title: buildText(
            'Products',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          actions: [
            Consumer<PetListProvider>(builder: (context, provider, _) {
              return TextButton(
                onPressed: () {
                  provider.addPet(context);
                },
                child: provider.isLoading
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
              );
            })
          ]),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    //BuildSearchBar(),
                    _subCategoryList(),

                    pets.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: GridView.builder(
                                itemCount: pets.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1 / 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, i) {
                                  Map data = pets[i];
                                  return PetItem(
                                    index: i,
                                    data: data,
                                    groupValue: _selectedPet,
                                    onSelected: (v) {
                                      setState(() {
                                        _selectedPet = v;
                                      });
                                    },
                                  );
                                }),
                          )
                        : _emptyText(),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _subCategoryList() {
    return Visibility(
      visible: _subcategories.isNotEmpty ? true : false,
      child: Container(
        height: 48.0,
        child: ListView.builder(
          padding: EdgeInsets.only(left: 24.0),
          scrollDirection: Axis.horizontal,
          itemCount: _subcategories.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(right: 8.0),
              child: InputChip(
                backgroundColor: Colors.transparent,
                side: BorderSide(color: Colors.grey.shade700),
                label: Text(_subcategories[index]['category']),
                onPressed: () {
                  nav(context, PetList(data: _subcategories[index]));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _emptyText() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(child: Text('No products.')),
    );
  }
}
