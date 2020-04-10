import 'dart:typed_data';

import 'package:dio/dio.dart';

abstract class CloudinaryBaseApi {
  final Dio _dio = Dio();
  final String API_BASE_URL = "https://api.cloudinary.com/v1_1/";

  Future<Dio> getApiClient({InterceptorsWrapper interceptor}) async {
    _dio.options.baseUrl = API_BASE_URL;
    _dio.interceptors.clear();
    if (interceptor != null) {
      _dio.interceptors.add(interceptor);
    }
    return _dio;
  }

  Future<Map<String, dynamic>> upload(String path,
      {String filename, String folder});
  Future<Map<String, dynamic>> uploadFromBytes(Uint8List file, String filename,
      {String folder});

  Future<List<Map<String, dynamic>>> uploadMultiple(
    List<String> paths, {
    List<String> filenames,
    String folder,
  }) async {
    List<Map<String, dynamic>> responses = [];
    filenames = filenames ?? paths;
    for (int i = 0; i < paths.length; i++) {
      Map<String, dynamic> resp = await upload(
        paths[i],
        filename: filenames[i],
        folder: folder,
      );
      responses.add(resp);
    }
    return responses;
  }

  Future<List<Map<String, dynamic>>> uploadMultipleFromBytes(
    List<Uint8List> files,
    List<String> filenames, {
    String folder,
  }) async {
    List<Map<String, dynamic>> responses = [];
    for (int i = 0; i < files.length; i++) {
      Map<String, dynamic> resp = await uploadFromBytes(
        files[i],
        filenames[i],
        folder: folder,
      );
      responses.add(resp);
    }
    return responses;
  }
}
