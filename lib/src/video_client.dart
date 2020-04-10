import 'dart:typed_data';

import 'package:cloudinary_client/src/credentials.dart';
import 'package:dio/dio.dart';
import 'base_api.dart';

class Video extends CloudinaryBaseApi {
  final Credentials credentials;

  Video(this.credentials);

  Future<Map<String, dynamic>> uploadFromBytes(
    Uint8List file,
    String filename, {
    String folder,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    if (file == null) {
      throw Exception("video must not be null");
    }
    if (filename == null) {
      throw Exception("videoFileName must not be null");
    }

    String publicId = filename.split('.')[0] + "_" + timestamp.toString();

    Map<String, dynamic> params = {
      "file": await MultipartFile.fromBytes(file.toList(), filename: filename),
      "api_key": credentials.apiKey,
      "timestamp": timestamp,
      "signature": credentials.getSignature(folder, publicId, timestamp),
      if (folder != null) "folder": folder,
      if (publicId != null) "public_id": publicId,
    };

    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(credentials.cloudName + "/video/upload", data: formData);

    return response.data;
  }

  Future<Map<String, dynamic>> upload(
    String path, {
    String filename,
    String folder,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    if (path == null) {
      throw Exception("videoPath must not be null");
    }
    String publicId = path.split('/').last;
    publicId = publicId.split('.')[0];

    if (filename != null) {
      publicId = filename.split('.')[0] + "_" + timestamp.toString();
    } else {
      filename = publicId;
    }

    Map<String, dynamic> params = {
      "file": await MultipartFile.fromFile(path, filename: filename),
      "api_key": credentials.apiKey,
      "timestamp": timestamp,
      "signature": credentials.getSignature(folder, publicId, timestamp),
      if (folder != null) "folder": folder,
      if (publicId != null) "public_id": publicId,
    };
    FormData formData = FormData.fromMap(params);

    Dio dio = await getApiClient();
    Response response =
        await dio.post(credentials.cloudName + "/video/upload", data: formData);

    return response.data;
  }
}
