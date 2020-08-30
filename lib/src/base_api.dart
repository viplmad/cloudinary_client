import 'dart:typed_data';

abstract class CloudinaryBaseApi {
  final String baseUrl;

  CloudinaryBaseApi() : baseUrl = "https://api.cloudinary.com/v1_1/";

  Future<Map<String, dynamic>> upload(String path,
      {String filename, String folder});
  Future<Map<String, dynamic>> uploadFromUrl(String url,
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
