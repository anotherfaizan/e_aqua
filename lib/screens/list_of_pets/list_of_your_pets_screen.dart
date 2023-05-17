import 'package:aquatic_vendor_app/app_providers/pet_list_provider.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/custom_appbar.dart';
import 'package:aquatic_vendor_app/repositories/product_repository.dart';
import 'package:aquatic_vendor_app/screens/home_screen/widgets/new_order_item.dart';
import 'package:aquatic_vendor_app/widgets/add_new_pet_button.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'widgets/list_item.dart';

class ListOfYourPetsScreen extends StatefulWidget {
  const ListOfYourPetsScreen({Key? key}) : super(key: key);

  @override
  State<ListOfYourPetsScreen> createState() => _ListOfYourPetsScreenState();
}

class _ListOfYourPetsScreenState extends State<ListOfYourPetsScreen> {
  ProductRepository _productRepository = ProductRepository();
  static const _pageSize = 10;
  final _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _productRepository.getVendorAllProducts(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final int nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, AppColors.backgroundColor);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: buildText(
          'List of your products',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        automaticallyImplyLeading: false,
      ),
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: AddNewPetButton(),
                  ),
                ],
              ),
            ),
          ];
        },
        body: _list(),
      ),
    );
  }

  Widget _list() {
    return Selector<PetListProvider, bool>(
      selector: (context, provider) => provider.isNewProductAdded,
      builder: (context, bool newProductAdded, _) {
        if (newProductAdded) {
          _pagingController.refresh();
        }
        return PagedListView<int, dynamic>(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          physics: NeverScrollableScrollPhysics(),
          addAutomaticKeepAlives: true,
          shrinkWrap: true,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            itemBuilder: (context, data, index) {
              return ListItem(
                data: data,
                pagingController: _pagingController,
                index: index,
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Text(
                    'No Data.',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
