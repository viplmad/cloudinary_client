import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'base_api.dart';

class VideoClient extends BaseApi {
  @override
  String cloudName;
  @override
  String apiKey;
  @override
  String apiSecret;

  VideoClient(this.apiKey, this.apiSecret, this.cloudName);

  Future<Map<String, dynamic>> uploadVideoFromBytes(
    Uint8List video,
    String videoFileName, {
    String folder,
  }) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {};
    if (apiSecret == null || apiKey == null) {
      throw Exception("apiKey and apiSecret must not be null");
    }

    params["api_key"] = apiKey;

    if (video == null) {
      throw Exception("video must not be null");
    }
    if (videoFileName == null) {
      throw Exception("videoFileName must not be null");
    }

    String publicId = videoFileName.split('.')[0] + "_" + timeStamp.toString();

    if (folder != null) {
      params["folder"] = folder;
    }

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    params["file"] =
        await MultipartFile.fromBytes(video.toList(), filename: videoFileName);
    params["timestamp"] = timeStamp;
    params["signature"] = getSignature(folder, publicId, timeStamp);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(cloudName + "/video/upload", data: formData);

    return response.data;
  }

  Future<Map<String, dynamic>> uploadVideo(
    String videoPath, {
    String videoFileName,
    String folder,
  }) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {};
    if (apiSecret == null || apiKey == null) {
      throw Exception("apiKey and apiSecret must not be null");
    }

    params["api_key"] = apiKey;

    if (videoPath == null) {
      throw Exception("videoPath must not be null");
    }
    String publicId = videoPath.split('/').last;
    publicId = publicId.split('.')[0];

    if (videoFileName != null) {
      publicId = videoFileName.split('.')[0] + "_" + timeStamp.toString();
    } else {
      videoFileName = publicId;
    }

    if (folder != null) {
      params["folder"] = folder;
    }

    if (publicId != null) {
      params["public_id"] = publicId;
    }

    params["file"] =
        await MultipartFile.fromFile(videoPath, filename: videoFileName);
    params["timestamp"] = timeStamp;
    params["signature"] = getSignature(folder, publicId, timeStamp);

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(cloudName + "/video/upload", data: formData);

    return response.data;
  }
}
