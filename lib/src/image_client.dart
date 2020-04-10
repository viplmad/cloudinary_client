import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'base_api.dart';

class ImageClient extends BaseApi {
  @override
  String cloudName;
  @override
  String apiKey;
  @override
  String apiSecret;

  ImageClient(this.apiKey, this.apiSecret, this.cloudName);

  Future<Map<String, dynamic>> uploadImageFromBytes(
    Uint8List image,
    String imageFilename, {
    String folder,
  }) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {};
    if (apiSecret == null || apiKey == null) {
      throw Exception("apiKey and apiSecret must not be null");
    }

    params["api_key"] = apiKey;

    if (image == null) {
      throw Exception("image must not be null");
    }
    if (imageFilename == null) {
      throw Exception("image must not be null");
    }
    String publicId = imageFilename.split('.')[0] + "_" + timeStamp.toString();

    if (folder != null) {
      params["folder"] = folder;
    }

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    params["file"] =
        await MultipartFile.fromBytes(image.toList(), filename: imageFilename);
    params["timestamp"] = timeStamp;
    params["signature"] = getSignature(folder, publicId, timeStamp);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(cloudName + "/image/upload", data: formData);

    return response.data;
  }

  Future<Map<String, dynamic>> uploadImage(
    String imagePath, {
    String imageFilename,
    String folder,
  }) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {};
    if (apiSecret == null || apiKey == null) {
      throw Exception("apiKey and apiSecret must not be null");
    }

    params["api_key"] = apiKey;

    if (imagePath == null) {
      throw Exception("imagePath must not be null");
    }
    String publicId = imagePath.split('/').last;
    publicId = publicId.split('.')[0];

    if (imageFilename != null) {
      publicId = imageFilename.split('.')[0] + "_" + timeStamp.toString();
    } else {
      imageFilename = publicId;
    }

    if (folder != null) {
      params["folder"] = folder;
    }

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    params["file"] =
        await MultipartFile.fromFile(imagePath, filename: imageFilename);
    params["timestamp"] = timeStamp;
    params["signature"] = getSignature(folder, publicId, timeStamp);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(cloudName + "/image/upload", data: formData);

    return response.data;
  }
}
