import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSearchBar extends StatefulWidget {
  const BuildSearchBar({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  State<BuildSearchBar> createState() => _BuildSearchBarState();
}

class _BuildSearchBarState extends State<BuildSearchBar> {
  late PetListProvider _petListProvider;

  @override
  void initState() {
    super.initState();
    _petListProvider = Provider.of(context, listen: false);
  }

  @override
  void dispose() {
    _petListProvider.clearSearch(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: TextField(
        onChanged: (value) {
          _search(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(Icons.search),
          contentPadding: const EdgeInsets.only(top: 8),
          hintText: widget.text ?? 'Search your product',
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  void _search(String keyword) {
    if (keyword.characters.length >= 3) {
      //search product
      _petListProvider.searchProducts(keyword);
    } else {
      if (_petListProvider.showSearchResults) {
        //clear search
        _petListProvider.clearSearch();
      }
    }
  }
}
