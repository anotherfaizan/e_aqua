import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/app_global_variables.dart';
import 'package:aquatic_vendor_app/app_utils/compute_functions.dart';
import 'package:aquatic_vendor_app/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PetListProvider extends ChangeNotifier {
  ProductRepository _productRepository = ProductRepository();

  List _allCategories = [];
  List _allProducts = [];

  List productCategories = [];
  List petList = [];

  bool isLoading = false;

  Map selectedPet = {};

  List searchResultsList = [];

  bool isNewProductAdded = false;
  bool showSearchResults = false;

  String petCount() {
    return _allProducts.length.toString();
  }

  Future<void> getProductCategories() async {
    try {
      //get categories
      Map res = await _productRepository.getProductCategories();
      List categoryList = res['details'];
      _allCategories = categoryList;

      productCategories = _filterProductCateogories();

      //get all products
      Map resP = await _productRepository.getAllProducts();
      Map products = resP;
      _allProducts = await compute(mergePetList, products);
    } catch (e) {}
  }

  List _filterProductCateogories() {
    List list = [];

    _allCategories.forEach((element) {
      if (element != null) {
        Map data = element as Map;
        if (data['parent_category'] == null) {
          list.add(data);
        }
      }
    });

    return list;
  }

  Future<List> productsByCategoryId(String categoryId) async {
    final list = [];

    await Future.forEach(_allProducts, (element) {
      if (element != null) {
        Map data = element as Map;
        if (padQuotes(data['product_category']) == categoryId) {
          list.add(data);
        }
      }
    });

    return list;
  }

  List getSubCategories(String parentCategoryId) {
    //pet list
    List subCategoryList = [];

    _allCategories.forEach((element) {
      if (padQuotes(element['parent_category']) == parentCategoryId) {
        subCategoryList.add(element);
      }
    });

    return subCategoryList;
  }

  void searchProducts(String keyword) {
    List list = [];

    _allProducts.forEach((element) {
      if (padQuotes(element['product_name']).toLowerCase().contains(keyword)) {
        list.add(element);
      } else if (padQuotes(element['product_name'])
          .toLowerCase()
          .contains(keyword)) {
        list.add(element);
      }
    });

    searchResultsList = list;
    showSearchResults = true;
    notifyListeners();
  }

  void clearSearch([bool notify = true]) {
    searchResultsList.clear();
    showSearchResults = false;
    selectedPet = {};
    if (notify) notifyListeners();
  }

  void addPet(BuildContext context) async {
    _isLoading(true);

    try {
      Map res = await _productRepository.addProduct(
        productId: padQuotes(selectedPet['Product_id']),
      );

      if (res.containsKey('successMsg')) {
        SnackBarService.showSnackBar(
          context: context,
          message: res['successMsg'],
        );
        isNewProductAdded = true;
      }
    } catch (e) {
      SnackBarService.showSnackBar(
        context: context,
        message: 'Something went wrong.',
      );
    }

    _isLoading(false);
  }

  void setSelectedPet(Map data) {
    if (isNewProductAdded) {
      isNewProductAdded = false;
    }
    selectedPet = data;
    notifyListeners();
  }

  void _isLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
