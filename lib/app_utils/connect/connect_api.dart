import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ConnectApi {
  static const String _BASE_URL = "https://9demos.com/A1Aquatic/public/api/";
  static const String BASE_URL_IMAGE =
      "https://9demos.com/A1Aquatic/storage/app/";

  static Future postCallMethod(
    String url, {
    Map? body,
    bool customUrl: false,
  }) async {
    http.Response? response;
    try {
      debugPrint("postCallMethod");
      if (customUrl == true) {
        debugPrint("url:$url");
      }
      if (customUrl == false) {
        debugPrint("url:${_BASE_URL + url}");
      }
      if (body != null) debugPrint("body:$body");
      response = await http.post(
        Uri.parse(customUrl == true ? url : _BASE_URL + url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );
    } catch (e) {
      debugPrint("postCallMethod Exception: $e");
    }
    // debugPrint("response.request.url.path:\t${response.request.url}");
    debugPrint("response.statusCode:\t${response!.statusCode}");
    // debugPrint("response headers:\t${response.headers}");
    debugPrint("response.body:\t${response.body}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      return json.decode(response.body);
    }
    return Future.value(null);
  }

  static Future getCallMethod(String url,
      {bool bodyBytes: false, String? useCustomURL}) async {
    http.Response? response;
    try {
      debugPrint("getCallMethod");
      debugPrint("url:${_BASE_URL + url}");
      response = await http.get(
        Uri.parse(useCustomURL ?? (_BASE_URL + url)),
        headers: {},
      );
    } catch (e) {
      debugPrint("getCallMethod Exception: $e");
    }
    debugPrint("response.statusCode:\t${response!.statusCode}");
    // debugPrint("response headers:\t${response.headers}");
    debugPrint("response.body:\t${response.body}");

    if (response.statusCode == 200) {
      if (bodyBytes) {
        return response.bodyBytes;
      } else {
        return json.decode(response.body);
      }
    } else if (response.statusCode == 401) {
      if (bodyBytes) {
        return response.bodyBytes;
      } else {
        return json.decode(response.body);
      }
    }
    return Future.value(null);
  }

  static Future putCallMethod(
    String url, {
    Map? body,
    bool bodyBytes: false,
  }) async {
    http.Response? response;
    try {
      debugPrint("putCallMethod");
      debugPrint("url:${_BASE_URL + url}");
      if (body != null) debugPrint("body:$body");
      response = await http.put(
        Uri.parse(_BASE_URL + url),
        headers: {},
        body: body,
      );
    } catch (e) {
      debugPrint("putCallMethod Exception: $e");
    }
    debugPrint("response.statusCode:\t${response!.statusCode}");
    // debugPrint("response headers:\t${response.headers}");
    debugPrint("response.body:\t${response.body}");
    if (response.statusCode == 200) {
      if (bodyBytes) {
        return response.bodyBytes;
      } else {
        return json.decode(response.body);
      }
    } else if (response.statusCode == 401) {
      if (bodyBytes) {
        return response.bodyBytes;
      } else {
        return json.decode(response.body);
      }
    }
    return Future.value(null);
  }

  static Future deleteCallMethod(String url) async {
    http.Response? response;
    try {
      debugPrint("deleteCallMethod");
      debugPrint("url:${_BASE_URL + url}");
      response = await http.delete(
        Uri.parse(_BASE_URL + url),
        headers: {},
      );
    } catch (e) {
      debugPrint("deleteCallMethod Exception: $e");
    }
    debugPrint("response.statusCode:\t${response!.statusCode}");
    // debugPrint("response headers:\t${response.headers}");
    debugPrint("response.body:\t${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      return json.decode(response.body);
    }
    return Future.value(null);
  }

  static Future uploadSingleImage(
    String url, {
    required File imageFile,
    required String parameter,
  }) async {
    debugPrint("uploadSingleImage");
    debugPrint("url:${_BASE_URL + url}");
    var stream = http.ByteStream(Stream.castFrom(imageFile
        .openRead())); //new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(_BASE_URL + url);

    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll({});
    var multipartFile = new http.MultipartFile(parameter, stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    debugPrint("response.statusCode:\t${response.statusCode}");
    return json.decode(await response.stream.bytesToString());
  }

  static Future uploadSingleFile(
    String url, {
    required File? uploadFile,
    required String fileParameter,
    Map<String, String>? body,
  }) async {
    debugPrint("uploadSingleFile");
    debugPrint("url:${_BASE_URL + url}");
    if (body != null) debugPrint("body:$body");
    var uri = Uri.parse(_BASE_URL + url);
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll({});
    if (uploadFile != null) {
      var stream = http.ByteStream(Stream.castFrom(uploadFile
          .openRead())); //new http.ByteStream(DelegatingStream.typed(uploadFile.openRead()));
      var length = await uploadFile.length();

      var multipartFile = new http.MultipartFile(fileParameter, stream, length,
          filename: basename(uploadFile.path));
      request.files.add(multipartFile);
    }

    if (body != null) {
      request.fields.addAll(body);
    }
    //contentType: new MediaType('image', 'png'));
    var response = await request.send();
    debugPrint("response.statusCode:\t${response.statusCode}");
    // debugPrint("response.headers:\t${response.headers}");
    // debugPrint("response.body:/t${await response.stream.bytesToString()}");
    return json.decode(await response.stream.bytesToString());
  }

  /// upload Multiple File
  static Future uploadMultipleFile(
    String url, {
    required List<File?> uploadFiles,
    required List<String> fileParameters,
    var body,
  }) async {
    debugPrint('uploadMultipleFile');
    debugPrint('url:${_BASE_URL + url}');
    //var _imageKey = fileParameter;

    var uri = Uri.parse(_BASE_URL + url);
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({});

    if (uploadFiles.isNotEmpty) {
      for (var index = 0; index < uploadFiles.length; index++) {
        if (uploadFiles[index] != null) {
          var file = uploadFiles[index];
          var stream = http.ByteStream(file!.openRead());
          var length = await file.length();

          /* // to make image key image, image2, image 3
        if (index != 0) {
          _imageKey = fileParameter + cNumeric(index + 1);
        } */

          var multipartFile = http.MultipartFile(
            fileParameters[index],
            stream.cast(),
            length,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);
        }
      }
    }

    if (body != null) {
      debugPrint('body:$body');
      request.fields.addAll(body);
    } else {
      request.fields.addAll({});
    }
    var response = await request.send();
    debugPrint('response.statusCode:\t${response.statusCode}');
    debugPrint(response.reasonPhrase.toString());
    return json.decode(await response.stream.bytesToString());
  }
}
