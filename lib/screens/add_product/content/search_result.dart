import 'dart:developer';

import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/screens/pet_list/widgets/pet_item.dart';
import 'package:aquatic_vendor_app/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatefulWidget {
  SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late PetListProvider _petListProvider;
  String _selectedPet = '';

  @override
  void initState() {
    super.initState();
    _petListProvider = Provider.of(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
              itemCount: _petListProvider.searchResultsList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                Map data = _petListProvider.searchResultsList[index];

               

                return PetItem(
                  groupValue: _selectedPet,
                  index: index,
                  data: data,
                  onSelected: (v) {
                    setState(() {
                      _selectedPet = v;
                    });
                  },
                );
              }),
        ),
      ),
    );
  }
}
