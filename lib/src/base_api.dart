import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import 'credentials.dart';
import 'cloudinary_response.dart';


abstract class CloudinaryBaseApi {
  static const String baseUrl = 'https://api.cloudinary.com/v1_1/';

  final Credentials credentials;

  const CloudinaryBaseApi(this.credentials);

  Future<CloudinaryResponse> upload(
    String path, {
    String? filename,
    String? folder,
    bool uniqueFilename = true,
  });

  Future<CloudinaryResponse> uploadFromBytes(
    Uint8List file,
    String filename, {
    String? folder,
    bool uniqueFilename = true,
  });

  Future<CloudinaryResponse> uploadFromUrl(
    String url, {
    String? filename,
    String? folder,
    bool uniqueFilename = true,
  });

  Future<List<CloudinaryResponse>> uploadMultiple(
    List<String> paths, {
    List<String>? filenames,
    String? folder,
    bool uniqueFilename = true,
  }) async {
    List<CloudinaryResponse> responses = [];
    filenames = filenames ?? paths;
    for (int i = 0; i < paths.length; i++) {
      CloudinaryResponse resp = await upload(
        paths.elementAt(i),
        filename: filenames.elementAt(i),
        folder: folder,
        uniqueFilename: uniqueFilename,
      );
      responses.add(resp);
    }
    return responses;
  }

  Future<List<CloudinaryResponse>> uploadMultipleFromBytes(
    List<Uint8List> files,
    List<String> filenames, {
    String? folder,
  }) async {
    List<CloudinaryResponse> responses = [];
    for (int i = 0; i < files.length; i++) {
      CloudinaryResponse resp = await uploadFromBytes(
        files.elementAt(i),
        filenames.elementAt(i),
        folder: folder,
      );
      responses.add(resp);
    }
    return responses;
  }

  Future<CloudinaryResponse> executeRequest(MultipartRequest req) async {
    try {

      final StreamedResponse resp = await req.send();
      final String respBody = await resp.stream.bytesToString();
      Map<String, Object?> jsonMap = jsonDecode(respBody);
      return CloudinaryResponseSuccess.fromJsonMap(jsonMap);

    } catch(error) {

      return CloudinaryResponseError(error.toString());

    }
  }

  String getPublicIdFromPath(String path) {

    return path.split('/').last.split('.').first;

  }
}
