import 'dart:typed_data';

import 'credentials.dart';


abstract class CloudinaryBaseApi {
  static const String baseUrl = 'https://api.cloudinary.com/v1_1/';

  final Credentials credentials;

  const CloudinaryBaseApi(this.credentials);

  Future<Map<String, Object?>> upload(
    String path, {
    String? filename,
    String? folder,
    bool uniqueFilename = true,
  });

  Future<Map<String, Object?>> uploadFromBytes(
    Uint8List file,
    String filename, {
    String? folder,
    bool uniqueFilename = true,
  });

  Future<Map<String, Object?>> uploadFromUrl(
    String url, {
    String? filename,
    String? folder,
    bool uniqueFilename = true,
  });

  Future<List<Map<String, Object?>>> uploadMultiple(
    List<String> paths, {
    List<String>? filenames,
    String? folder,
    bool uniqueFilename = true,
  }) async {
    List<Map<String, Object?>> responses = [];
    filenames = filenames ?? paths;
    for (int i = 0; i < paths.length; i++) {
      Map<String, Object?> resp = await upload(
        paths.elementAt(i),
        filename: filenames.elementAt(i),
        folder: folder,
        uniqueFilename: uniqueFilename,
      );
      responses.add(resp);
    }
    return responses;
  }

  Future<List<Map<String, Object?>>> uploadMultipleFromBytes(
    List<Uint8List> files,
    List<String> filenames, {
    String? folder,
  }) async {
    List<Map<String, Object?>> responses = [];
    for (int i = 0; i < files.length; i++) {
      Map<String, Object?> resp = await uploadFromBytes(
        files.elementAt(i),
        filenames.elementAt(i),
        folder: folder,
      );
      responses.add(resp);
    }
    return responses;
  }

  String getPublicIdFromPath(String path) {

    return path.split('/').last.split('.').first;

  }
}
