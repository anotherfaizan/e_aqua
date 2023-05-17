import 'package:aquatic_vendor_app/app_service/dialog_service.dart';
import 'package:aquatic_vendor_app/app_service/snackbar_service.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/repositories/product_repository.dart';
import 'package:aquatic_vendor_app/screens/details_screen/details_screen.dart';
import 'package:aquatic_vendor_app/screens/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListItem extends StatefulWidget {
  final Map data;
  final PagingController pagingController;
  final index;
  const ListItem({
    Key? key,
    this.fontFamily,
    required this.data,
    required this.pagingController,
    required this.index,
  }) : super(key: key);
  final String? fontFamily;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  ProductRepository _productRepository = ProductRepository();

  void _removeProduct() async {
    bool? res = await DialogService.removeDialogConfirmation(context: context);

    if (res != null && res) {
      try {
        Map res = await _productRepository.removeProduct(
          productId: padQuotes(widget.data['Product_id']),
        );
        widget.pagingController.itemList!.removeAt(widget.index);
        widget.pagingController.notifyListeners();

        if (res.containsKey('successMsg')) {
          SnackBarService.showSnackBar(
            context: context,
            message: 'Removed.',
          );
        }
      } catch (e) {
        SnackBarService.showSnackBar(
          context: context,
          message: 'Something went wrong.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
 
    return GestureDetector(
      onTap: () {
        productDetailsNav(context, widget.data);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    // height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                            child: Image.network(
                              ConnectApi.BASE_URL_IMAGE +
                                  padQuotes(widget.data['product_image1']),
                              fit: BoxFit.cover,
                              height: 120,
                              errorBuilder: (
                                BuildContext context,
                                Object exception,
                                _,
                              ) {
                                return Image.asset(
                                  AppConstants.assetImages + 'placholder.png',
                                  fit: BoxFit.cover,
                                  height: 120,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildText(
                                    padQuotes(widget.data['product_name']),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: widget.fontFamily,
                                    fontSize: 16,
                                    maxLine: 2,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(
                                  height: 4,
                                ),
                                ...buildAge(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 5,
                    child: buildText(
                      '₹ ${widget.data['price']}/-',
                      alignment: TextAlign.right,
                      fontFamily: widget.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Icon(
                      Icons.male,
                      size: 35,
                      color: AppColors.PrimaryColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {
                  _removeProduct();
                },
                child: buildText(
                  'Remove',
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildAge() {
    return [
      buildItemRow(
        image: 'pet_age.png',
        text: '${widget.data['age']} months old',
      ),
      SizedBox(
        height: 5,
      ),
    ];
  }

  Row buildItemRow({
    String? image,
    IconData? icon,
    String? text,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.lightBlue[100],
          radius: 15,
          child: image == null
              ? Icon(
                  icon,
                  color: AppColors.PrimaryColor,
                )
              : Image.asset(
                  AppConstants.assetImages + image,
                  fit: BoxFit.fill,
                ),
        ),
        SizedBox(
          width: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: buildText(
            _subtextByType(),
            fontColor: Colors.grey[600],
            alignment: TextAlign.left,
            fontFamily: widget.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _subtextByType() {
    String text = '';

    switch (widget.data['product_type']) {
      case 'Live product':
        text = padQuotes(widget.data['age']) + ' old';
        break;
      case 'Food':
        text = padQuotes(widget.data['brand']);
        break;
      case 'AQUARIUM':
        text = padQuotes(widget.data['brand']);
        break;
      case 'Equipment':
        text = padQuotes(widget.data['brand']);
        break;
      case 'Service booking':
        text = '';
        break;
      default:
    }

    return text;
  }
}
