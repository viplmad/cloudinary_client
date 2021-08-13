import 'dart:convert';

import 'package:crypto/crypto.dart';


class Credentials {
  static const List<String> _forbidden = <String>['file', 'cloud_name', 'resource_type', 'api_key'];

  final String apiKey;
  final String apiSecret;
  final String cloudName;

  const Credentials(this.apiKey, this.apiSecret, this.cloudName);

  String getSignature(Map<String, String> fields) {
    final List<String> sortedParams = fields.keys.toList(growable: false)..sort();

    final StringBuffer signBuffer = StringBuffer();
    for(int i = 0; i < sortedParams.length; i++) {
      final String param = sortedParams[i];

      if (_isNotForbiddenParam(param)) {
        final String value = fields[param]!;

        signBuffer.write('$param=$value');

        if(i < sortedParams.length-1) {
          signBuffer.write('&');
        }
      }
    }
    signBuffer.write(apiSecret);

    final List<int> bytes = utf8.encode(signBuffer.toString().trim()); // data being hashed

    return sha1.convert(bytes).toString();
  }

  bool _isNotForbiddenParam(String param) {
    return !_forbidden.contains(param);
  }
}
