import 'dart:typed_data';

import 'package:http/http.dart';

import 'base_api.dart';
import 'credentials.dart';
import 'cloudinary_response.dart';


class Video extends CloudinaryBaseApi {
  const Video(Credentials credentials) : super(credentials);

  @override
  Future<CloudinaryResponse> upload(
    String path, {
    String? filename,
    String? folder,
  }) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    String publicId = getPublicIdFromPath(path);

    if (filename != null) {
      publicId = filename.split('.').first + '_' + timestamp.toString();
    } else {
      filename = publicId;
    }

    final Map<String, String> fields = <String, String>{
      'api_key': credentials.apiKey,
      'timestamp': timestamp.toString(),
      'public_id': publicId,
      if (folder != null) 'folder': folder,
    };

    final MultipartRequest req = MultipartRequest(
        'POST', Uri.parse(CloudinaryBaseApi.baseUrl + credentials.cloudName + '/video/upload'))
      ..fields.addAll(fields)
      ..fields['signature'] = credentials.getSignature(fields)
      ..files
          .add(await MultipartFile.fromPath('file', path, filename: filename));

    return executeRequest(req);
  }

  @override
  Future<CloudinaryResponse> uploadFromBytes(
    Uint8List file,
    String filename, {
    String? folder,
  }) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final String publicId = filename.split('.').first + '_' + timestamp.toString();

    final Map<String, String> fields = <String, String>{
      'api_key': credentials.apiKey,
      'timestamp': timestamp.toString(),
      'public_id': publicId,
      if (folder != null) 'folder': folder,
    };

    final MultipartRequest req = MultipartRequest(
        'POST', Uri.parse(CloudinaryBaseApi.baseUrl + credentials.cloudName + '/video/upload'))
      ..fields.addAll(fields)
      ..fields['signature'] = credentials.getSignature(fields)
      ..files.add(MultipartFile.fromBytes('file', file.toList(),
          filename: filename));

    return executeRequest(req);
  }

  @override
  Future<CloudinaryResponse> uploadFromUrl(
    String url, {
    String? filename,
    String? folder,
  }) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final String path = Uri.parse(url).path;

    String publicId = getPublicIdFromPath(path);

    if (filename != null) {
      publicId = filename.split('.').first + '_' + timestamp.toString();
    } else {
      filename = publicId;
    }

    final Map<String, String> fields = <String, String>{
      'api_key': credentials.apiKey,
      'timestamp': timestamp.toString(),
      'public_id': publicId,
      if (folder != null) 'folder': folder,
    };

    final MultipartRequest req = MultipartRequest(
        'POST', Uri.parse(CloudinaryBaseApi.baseUrl + credentials.cloudName + '/video/upload'))
      ..fields.addAll(fields)
      ..fields['signature'] = credentials.getSignature(fields);

    return executeRequest(req);
  }
}
