abstract class CloudinaryResponse {
  const CloudinaryResponse();
}

class CloudinaryResponseSuccess extends CloudinaryResponse {
  final String? publicId;
  final int? version;
  final int? width;
  final int? height;
  final String? format;
  final String? createdAt;
  final String? resourceType;
  final List<Object?>? tags;
  final int? bytes;
  final String? type;
  final String? etag;
  final String? url;
  final String? secureUrl;
  final String? signature;
  final String? originalFilename;

  CloudinaryResponseSuccess.fromJsonMap(Map<String, Object?> map)
  : publicId = map['public_id'] as String,
    version = map['version'] as int,
    width = map['width'] as int,
    height = map['height'] as int,
    format = map['format'] as String,
    createdAt = map['created_at'] as String,
    resourceType = map['resource_type'] as String,
    tags = map['tags'] as List<Object?>,
    bytes = map['bytes'] as int,
    type = map['type'] as String,
    etag = map['etag'] as String,
    url = map['url'] as String,
    secureUrl = map['secure_url'] as String,
    signature = map['signature'] as String,
    originalFilename = map['original_filename'] as String;

  Map<String, Object?> toJson() {
    final Map<String, Object?> data = Map<String, Object?>();
    data['public_id'] = publicId;
    data['version'] = version;
    data['width'] = width;
    data['height'] = height;
    data['format'] = format;
    data['created_at'] = createdAt;
    data['resource_type'] = resourceType;
    data['tags'] = tags;
    data['bytes'] = bytes;
    data['type'] = type;
    data['etag'] = etag;
    data['url'] = url;
    data['secure_url'] = secureUrl;
    data['signature'] = signature;
    data['original_filename'] = originalFilename;

    return data;
  }
}

class CloudinaryResponseError extends CloudinaryResponse {
  final String error;

  const CloudinaryResponseError(this.error);
}