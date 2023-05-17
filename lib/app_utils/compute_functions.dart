//PetListProvider merge petList from liveProducts Map
import 'dart:developer';

import 'package:aquatic_vendor_app/app_utils/app_enums.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:flutter/material.dart';

List filterProductCategories(List categoryList) {
  List list = [];
  categoryList.forEach((element) {
    if (element['parent_category'] == null) {
      list.add(element);
    }
  });
  return list;
}

List mergePetList(Map productMap) {
  List products = [];

  try {
    productMap.keys.forEach((keys) {
      Map subProduct = productMap[keys];
      subProduct.keys.forEach((subProductKey) {
        List list = subProduct[subProductKey];
        list.forEach((item) {
          products.add(item);
        });
      });
    });
  } catch (e) {
    debugPrint('mergePetList compute error' + e.toString());
  }

  return products;
}

//PetListProvider merge petList from liveProducts Map
List productsByCategory(List data) {
  //list of data
  List unfilterList = data[0];
  String categoryId = data[1];

  //pet list
  List productList = [];

  unfilterList.forEach((element) {
    if (padQuotes(element['product_category']) == categoryId) {
      productList.add(element);
    }
  });
  return productList;
}

//get subcategories
List subCategories(List data) {
  //list of data
  List allCategories = data[0];
  String parentCategoryId = data[1];

  //pet list
  List subCategoryList = [];

  allCategories.forEach((element) {
    if (padQuotes(element['parent_category']) == parentCategoryId) {
      subCategoryList.add(element);
    }
  });

  return subCategoryList;
}
