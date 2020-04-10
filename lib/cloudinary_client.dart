library cloudinary_imageClient;

import 'package:cloudinary_client/src/image_client.dart';
import 'package:cloudinary_client/src/video_client.dart';

class CloudinaryClient {
  String _apiKey;
  String _apiSecret;
  String _cloudName;
  ImageClient _imageClient;
  VideoClient _videoClient;

  CloudinaryClient(String apiKey, String apiSecret, String cloudName) {
    this._apiKey = apiKey;
    this._apiSecret = apiSecret;
    this._cloudName = cloudName;
    _imageClient = ImageClient(_apiKey, _apiSecret, _cloudName);
    _videoClient = VideoClient(_apiKey, _apiSecret, _cloudName);
  }

  Future<Map<String, dynamic>> uploadImage(String imagePath,
      {String filename, String folder}) async {
    return _imageClient.uploadImage(imagePath,
        imageFilename: filename, folder: folder);
  }

  Future<List<Map<String, dynamic>>> uploadImages(List<String> imagePaths,
      {String filename, String folder}) async {
    List<Map<String, dynamic>> responses = List();

    for (var path in imagePaths) {
      Map<String, dynamic> resp = await _imageClient.uploadImage(path,
          imageFilename: filename, folder: folder);
      responses.add(resp);
    }
    return responses;
  }

  Future<List<String>> uploadImagesStringResp(List<String> imagePaths,
      {String filename, String folder}) async {
    List<String> responses = List();

    for (var path in imagePaths) {
      Map<String, dynamic> resp = await _imageClient.uploadImage(path,
          imageFilename: filename, folder: folder);
      responses.add(resp['url']);
    }
    return responses;
  }

  Future<Map<String, dynamic>> uploadVideo(String videoPath,
      {String filename, String folder}) async {
    return _videoClient.uploadVideo(videoPath,
        videoFileName: filename, folder: folder);
  }
}
