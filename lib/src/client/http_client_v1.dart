import 'package:lenco_flutter/src/client/base_http_client.dart';

/// HTTP client for Lenco API v1
class HttpClientV1 extends BaseHttpClient {
  HttpClientV1({required super.config, super.client});

  @override
  String get baseUrl => config.versionedBaseUrl;
}
