import 'dart:io';

import 'package:aquatic_vendor_app/app_models/media_list_model.dart';
import 'package:aquatic_vendor_app/app_utils/app_colors.dart';
import 'package:aquatic_vendor_app/app_utils/app_constants.dart';
import 'package:aquatic_vendor_app/app_utils/app_functions.dart';
import 'package:aquatic_vendor_app/app_utils/build_widgets.dart';
import 'package:aquatic_vendor_app/app_utils/connect/connect_api.dart';
import 'package:aquatic_vendor_app/screens/play_prouct_video/play_product_video.dart';
import 'package:aquatic_vendor_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ServiceBookingDetail extends StatefulWidget {
  final Map data;
  ServiceBookingDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<ServiceBookingDetail> createState() => _LiveProductState();
}

class _LiveProductState extends State<ServiceBookingDetail> {
  List<MediaListModel> _mediaList = [];

  @override
  void initState() {
    super.initState();
    _setMediaList();
  }

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

      if (widget.data[key] != null) {
        _mediaList.add(MediaListModel(name: widget.data[key], type: 'image'));
      }
    }

    //video
    for (int i = 1; i <= 5; i++) {
      String key = 'product_video$i';

      if (widget.data[key] != null) {
        _mediaList.add(MediaListModel(name: widget.data[key], type: 'video'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            _image(),
            _horizontalImages(),
            _details(),
            _infoList(),
            _otherDetails(),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 350,
      width: double.infinity,
      child: Image.network(
        ConnectApi.BASE_URL_IMAGE + padQuotes(widget.data['product_image1']),
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

  Widget _details() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildText(
                  padQuotes(widget.data['product_name']),
                  // fontColor: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              buildText(
                '₹ ${widget.data['price']}/-',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ],
          ),
          sizedBox(),
          Align(
            alignment: Alignment.centerLeft,
            child: buildText('About this product',
                fontColor: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          sizedBox(),
          buildText(
            padQuotes(widget.data['short_desc']),
            alignment: TextAlign.left,
            fontColor: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          sizedBox(),
          buildText(
            padQuotes(widget.data['full_description']),
            alignment: TextAlign.left,
            fontColor: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _infoList() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 100,
      alignment: Alignment.center,
      child: ListView(
        padding: EdgeInsets.only(left: 16.0),
        scrollDirection: Axis.horizontal,
        children: [
          buildListItem(
            title: widget.data['brand'] != null
                ? padQuotes(widget.data['brand'])
                : 'NA',
            image: 'pet_age_big.png',
          ),
          buildListItem(
            title: widget.data['length'] != null
                ? padQuotes(widget.data['length'])
                : 'NA',
            image: 'weight.png',
          ),
          buildListItem(
            title: widget.data['thickness'] != null
                ? padQuotes(widget.data['thickness'])
                : 'NA',
            image: 'weight.png',
          ),
          buildListItem(
            title: widget.data['length'] != null
                ? padQuotes(widget.data['length'])
                : 'NA',
            image: 'weight.png',
          ),
          buildListItem(
            title: widget.data['height'] != null
                ? padQuotes(widget.data['height'])
                : 'NA',
            image: 'weight.png',
          ),
          buildListItem(
            title: widget.data['width'] != null
                ? padQuotes(widget.data['width'])
                : 'NA',
            image: 'weight.png',
          ),
          buildListItem(
            title: widget.data['weight'] != null
                ? padQuotes(widget.data['weight'])
                : 'NA',
            image: 'weight.png',
          ),
        ],
      ),
    );
  }

  Widget _otherDetails() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: buildText(
              'Other Details',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          sizedBox(),
          buildDetailsRow('Category ', padQuotes(widget.data['category_name'])),
          buildDetailsRow('Size in mm', widget.data['size _in_mm'] ?? 'NA'),
          buildDetailsRow('Youtube Link ', widget.data['youtube_link'] ?? 'NA'),
        ],
      ),
    );
  }

  Widget buildListItem({required String title, required String? image}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 100,
      height: 100,
      // padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: image != null
                    ? FittedBox(
                        child: Image.asset(
                          AppConstants.assetImages + image,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : FittedBox(
                        child: Icon(
                          Icons.male,
                          color: AppColors.PrimaryColor,
                          size: 40,
                        ),
                      ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.PrimaryColorDark,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              width: double.infinity,
              child: buildText(title,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                  fontSize: 16,
                  alignment: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailsRow(String text1, String text2) {
    return Row(
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
    );
  }

  Widget sizedBox({double? height}) {
    return SizedBox(
      height: height ?? 10,
    );
  }
}
