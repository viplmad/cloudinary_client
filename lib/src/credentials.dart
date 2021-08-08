import 'dart:convert';

import 'package:crypto/crypto.dart';


class Credentials {
  static const List<String> _forbidden = <String>['file', 'cloud_name', 'resource_type', 'api_key'];

  final String apiKey;
  final String apiSecret;
  final String cloudName;

  const Credentials(this.apiKey, this.apiSecret, this.cloudName);

  String getSignature(Map<String, String> fields) {
    StringBuffer buffer = StringBuffer();

    List<String> keys = fields.keys.toList();
    keys.sort((a, b) => a.compareTo(b));

    fields.forEach((String k, String v) {
      if (!_forbidden.contains(k)) {
        buffer.write('&$k=$v');
      }
    });

    buffer.write(apiSecret);
    List<int> bytes =
        utf8.encode(buffer.toString().substring(1).trim()); // data being hashed

    return sha1.convert(bytes).toString();
  }
}
