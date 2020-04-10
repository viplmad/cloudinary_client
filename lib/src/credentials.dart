import 'dart:convert';

import 'package:crypto/crypto.dart';

class CloudinaryCredentials {
  final String apiKey;
  final String apiSecret;
  final String cloudName;
  final String baseUrl = "https://api.cloudinary.com/v1_1/";

  CloudinaryCredentials(this.apiKey, this.apiSecret, this.cloudName);
  String getSignature(String folder, String publicId, int timeStamp) {
    var buffer = StringBuffer();
    if (folder != null) {
      buffer.write("folder=" + folder + "&");
    }
    if (publicId != null) {
      buffer.write("public_id=" + publicId + "&");
    }
    buffer.write("timestamp=" + timeStamp.toString() + apiSecret);

    var bytes = utf8.encode(buffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();
  }
}
