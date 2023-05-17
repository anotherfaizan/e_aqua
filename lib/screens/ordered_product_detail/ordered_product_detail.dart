import 'dart:developer';
import 'dart:io';

import 'package:aquatic_vendor_app/app_models/media_list_model.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/repositories/product_repository.dart';
import 'package:aquatic_vendor_app/screens/play_prouct_video/play_product_video.dart';
import 'package:aquatic_vendor_app/screens/product_detail/widgets/info_list.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class OrderedProductDetail extends StatefulWidget {
  final int quantity;
  OrderedProductDetail({Key? key, required this.quantity}) : super(key: key);

  @override
  State<OrderedProductDetail> createState() => _OrderedProductDetailState();
}

class _OrderedProductDetailState extends State<OrderedProductDetail> {
  ProductRepository _productRepository = ProductRepository();

  Map data = {};

  @override
  void initState() {
    _getData = _getDetails();

    super.initState();
  }

  final List<Map<String, dynamic>> detailData = [
    {
      'image': 'pet_age_big.png',
      'title': '3.2 Years',
      'icon': null,
    },
    {
      'image': null,
      'title': 'Male',
      'icon': Icons.male,
    },
    {
      'image': 'weight.png',
      'title': '300g',
      'icon': null,
    },
  ];

  late Future _getData;

  Future _getDetails() async {
    Map data = await _productRepository.productbyId(productId: '1');
    return (data['products'] as List).first;
  }

  double get _orderTotalPrice {
    double productPrice = double.parse(data['price'].toString());
    return (productPrice * widget.quantity);
  }

  List<MediaListModel> _mediaList = [];

  Future _videoThumbnail(String videoURL) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: (await getTemporaryDirectory()).path,
      quality: 75,
    );

    return fileName;
  }

  void _setMediaList() {
    //image
    for (int i = 1; i <= 10; i++) {
      String key = 'product_image$i';

      if (data[key] != null) {
        _mediaList.add(MediaListModel(name: data[key], type: 'image'));
      }
    }

    //video
    for (int i = 1; i <= 5; i++) {
      String key = 'product_video$i';

      if (data[key] != null) {
        _mediaList.add(MediaListModel(name: data[key], type: 'video'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(context, Colors.transparent);
    return Scaffold(
      appBar: buildAppbar(context),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _getData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data as Map;
              _setMediaList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 350,
                            width: double.infinity,
                            child: Image.network(
                              ConnectApi.BASE_URL_IMAGE +
                                  padQuotes(data['product_image1']),
                              fit: BoxFit.cover,
                              errorBuilder: (
                                BuildContext context,
                                Object exception,
                                _,
                              ) {
                                return Image.asset(
                                  AppConstants.assetImages + 'placholder.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          // sizedBox(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                sizedBox(),
                                sizedBox(),
                                _horizontalImages(),
                                sizedBox(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildText(
                                      'Gold Fish',
                                      // fontColor: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    buildText(
                                      '₹ ${data['price']}/-',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ],
                                ),
                                sizedBox(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: buildText('About this pet',
                                      fontColor: Colors.grey[800],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                sizedBox(),
                                buildText(
                                  padQuotes(data['full_description']),
                                  alignment: TextAlign.left,
                                  fontColor: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                sizedBox(height: 20),
                                InfoList(data: data),

                                sizedBox(height: 20),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: buildText(
                                    'Other Details',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                sizedBox(),
                                // sizedBox(height: 20),
                                ...buildDetailsRow('Color', 'Red'),

                                ...buildDetailsRow('Sub name', 'Gold Fish'),
                                ...buildDetailsRow('Country origin', 'China'),
                                sizedBox(height: 20),
                                _orderInfo(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildBottomButton({
    String? text,
    Color? buttonColor,
    Color? borderColor,
    Color? textColor,
    void Function()? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            primary: buttonColor,
            side: BorderSide(
              width: 2,
              color: borderColor ?? Colors.transparent,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                )
              : buildText(
                  text ?? '',
                  fontColor: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
        ),
      ),
    );
  }

  Widget _horizontalImages() {
    return Visibility(
      visible: _mediaList.isNotEmpty,
      child: Container(
        constraints: BoxConstraints(maxHeight: 100),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _mediaList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _mediaList[i].type == 'image',
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          AppConstants.assetImages + 'fish_pic.png',
                          height: 80.0,
                          width: 120.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _mediaList[i].type == 'video',
                    child: GestureDetector(
                      onTap: () {
                        nav(
                          context,
                          PlayProductVideo(videoUrl: _mediaList[i].name),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FutureBuilder(
                                future: _videoThumbnail(_mediaList[i].name),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(snapshot.data),
                                        fit: BoxFit.cover,
                                        height: 80.0,
                                        width: 120.0,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            left: 0.0,
                            bottom: 0.0,
                            top: 0.0,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 32.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  RichText builtPrice() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Price  ',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: '₹ 1203.00',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 65,
      leading: Container(
        height: 40,
        width: 60,
        // padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 3,
            color: Colors.black,
          ),
          color: Colors.white,
        ),
        child: FittedBox(
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {
                navigationPop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          'Order Summary',
          fontColor: Colors.grey[800],
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        sizedBox(),
        ...buildDetailsRow(
            'Pet amount (Rs ${data['price']}*${widget.quantity})',
            '${_orderTotalPrice.toStringAsFixed(0)}'),
        Divider(
          indent: 0,
          color: Colors.black,
          height: 15,
        ),
        ...buildDetailsRow('Total', '${_orderTotalPrice.toStringAsFixed(0)}'),
        Divider(
          indent: 0,
          color: Colors.black,
          height: 2,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget sizedBox({double? height}) {
    return SizedBox(
      height: height ?? 10,
    );
  }

  List<Widget> buildDetailsRow(String text1, String text2) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildText(
            text1,
            fontColor: Colors.grey[800],
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          buildText(
            text2,
            fontColor: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ],
      ),
      sizedBox(),
    ];
  }
}
