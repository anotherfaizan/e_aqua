import 'dart:async';

import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  SearchInput(
    this.onSearchInput, {
    Key? key,
    this.searchInputKey,
    this.boxDecoration,
    this.hintText,
  }) : super(key: key);

  final ValueChanged<String>? onSearchInput;
  final Key? searchInputKey;
  final BoxDecoration? boxDecoration;
  final String? hintText;

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  Timer? debouncer;

  bool hasSearchEntry = false;

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput!(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer!.cancel();
    }

    debouncer = Timer(Duration(milliseconds: 500), () {
      widget.onSearchInput!(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        child: TextFormField(
          controller: editController,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Search place',
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
            ),
            suffixIcon: hasSearchEntry
                ? GestureDetector(
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      editController.clear();
                      setState(() {
                        hasSearchEntry = false;
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              hasSearchEntry = value.isNotEmpty;
            });
          },
        ),
      ),
    );
  }
}
