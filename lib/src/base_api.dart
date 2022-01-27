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
  });

  Future<CloudinaryResponse> uploadFromBytes(
    Uint8List file,
    String filename, {
    String? folder,
  });

  Future<CloudinaryResponse> uploadFromUrl(
    String url, {
    String? filename,
    String? folder,
  });

  Future<List<CloudinaryResponse>> uploadMultiple(
    List<String> paths, {
    List<String>? filenames,
    String? folder,
  }) async {
    final List<CloudinaryResponse> responses = <CloudinaryResponse>[];
    filenames = filenames ?? paths;
    for (int i = 0; i < paths.length; i++) {
      final CloudinaryResponse resp = await upload(
        paths.elementAt(i),
        filename: filenames.elementAt(i),
        folder: folder,
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
    final List<CloudinaryResponse> responses = <CloudinaryResponse>[];
    for (int i = 0; i < files.length; i++) {
      final CloudinaryResponse resp = await uploadFromBytes(
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
      if(resp.statusCode >= 400) {
        return CloudinaryResponseError(await resp.stream.bytesToString());
      }

      final String respBody = await resp.stream.bytesToString();
      final Map<String, Object?> jsonMap = jsonDecode(respBody) as Map<String, Object?>;
      return CloudinaryResponseSuccess.fromJsonMap(jsonMap);

    } catch(error) {

      return CloudinaryResponseError(error.toString());

    }
  }

  String getPublicIdFromPath(String path) {

    return path.split('/').last.split('.').first;

  }
}
