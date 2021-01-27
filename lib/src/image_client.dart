import 'dart:convert';
import 'dart:typed_data';

import 'package:cloudinary_client/src/credentials.dart';
import 'package:http/http.dart';
import 'base_api.dart';

class Image extends CloudinaryBaseApi {
  Credentials credentials;

  Image(this.credentials);

  Future<Map<String, dynamic>> uploadFromBytes(
    Uint8List file,
    String filename, {
    String folder,
    bool useFilename,
    bool uniqueFilename,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    if (file == null) {
      throw Exception("image must not be null");
    }
    if (filename == null) {
      throw Exception("image must not be null");
    }
    String publicId = filename.split('.')[0] + "_" + timestamp.toString();

    var req = MultipartRequest(
        'POST',
        Uri.parse(baseUrl +
            credentials.cloudName +
            "/image/upload" +
            addParams(useFilename, uniqueFilename)))
      ..fields.addAll({
        "api_key": credentials.apiKey,
        "timestamp": timestamp.toString(),
        "signature": credentials.getSignature(folder, publicId, timestamp),
        if (folder != null) "folder": folder,
        if (publicId != null) "public_id": publicId,
      })
      ..files.add(await MultipartFile.fromBytes('file', file.toList(),
          filename: filename));

    var resp = await req.send();
    var respBody = await resp.stream.bytesToString();
    return jsonDecode(respBody);
  }

  Future<Map<String, dynamic>> upload(
    String path, {
    String filename,
    String folder,
    bool useFilename,
    bool uniqueFilename,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    if (path == null) {
      throw Exception("imagePath must not be null");
    }
    String publicId = path.split('/').last;
    publicId = publicId.split('.')[0];

    if (filename != null) {
      publicId = filename.split('.')[0] + "_" + timestamp.toString();
    } else {
      filename = publicId;
    }

    var req = MultipartRequest(
        'POST',
        Uri.parse(baseUrl +
            credentials.cloudName +
            "/image/upload" +
            addParams(useFilename, uniqueFilename)))
      ..fields.addAll({
        "api_key": credentials.apiKey,
        "timestamp": timestamp.toString(),
        "signature": credentials.getSignature(folder, publicId, timestamp),
        if (folder != null) "folder": folder,
        if (publicId != null) "public_id": publicId,
      })
      ..files
          .add(await MultipartFile.fromPath('file', path, filename: filename));

    var resp = await req.send();
    var respBody = await resp.stream.bytesToString();
    return jsonDecode(respBody);
  }

  @override
  Future<Map<String, dynamic>> uploadFromUrl(
    String url, {
    String filename,
    String folder,
    bool useFilename,
    bool uniqueFilename,
  }) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    if (url == null) {
      throw Exception("imagePath must not be null");
    }
    var path = Uri.parse(url).path;

    String publicId = path.split('/').last;
    publicId = publicId.split('.')[0];

    if (filename != null) {
      publicId = filename.split('.')[0] + "_" + timestamp.toString();
    } else {
      filename = publicId;
    }

    var req = MultipartRequest(
        'POST',
        Uri.parse(baseUrl +
            credentials.cloudName +
            "/image/upload" +
            addParams(useFilename, uniqueFilename)))
      ..fields.addAll({
        "file": url,
        "api_key": credentials.apiKey,
        "timestamp": timestamp.toString(),
        "signature": credentials.getSignature(folder, publicId, timestamp),
        if (folder != null) "folder": folder,
        if (publicId != null) "public_id": publicId,
      });
    var resp = await req.send();
    var respBody = await resp.stream.bytesToString();
    return jsonDecode(respBody);
  }
}
