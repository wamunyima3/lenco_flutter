import 'package:lenco_flutter/src/client/base_http_client.dart';

/// HTTP client for Lenco API v2
class HttpClientV2 extends BaseHttpClient {
  HttpClientV2({required super.config, super.client});

  @override
  String get baseUrl => config.versionedBaseUrl;
}
