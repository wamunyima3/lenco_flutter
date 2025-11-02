import 'dart:async';

/// Configuration class for Lenco API
class LencoConfig {
  /// API key for authentication
  ///
  /// **Security:** Never commit API keys to version control. Use secure storage
  /// (e.g., `flutter_secure_storage`) or environment variables. See
  /// `docs/security.md` for best practices.
  final String apiKey;

  /// Base URL for API requests
  final String baseUrl;

  /// API version to use
  final LencoApiVersion version;

  /// Timeout duration for HTTP requests
  final Duration timeout;

  /// Enable debug logging
  final bool debugMode;

  /// Optional logger callback for request/response debugging
  /// If provided, this is used instead of print. Recommended to integrate
  /// with the host app's logging.
  final void Function(String message)? logger;

  /// Max automatic retries for transient failures (timeouts, 5xx, 429)
  final int maxRetries;

  /// Base backoff duration for retries
  final Duration retryBackoffBase;

  /// Optional request interceptor: modify endpoint/body/query before request
  final FutureOr<void> Function({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  })?
  onRequest;

  /// Optional response interceptor: observe raw response payloads
  final FutureOr<void> Function({
    required String method,
    required String endpoint,
    required int statusCode,
    required Map<String, dynamic> json,
  })?
  onResponse;

  const LencoConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.lenco.co',
    this.version = LencoApiVersion.v2,
    this.timeout = const Duration(seconds: 30),
    this.debugMode = false,
    this.logger,
    this.maxRetries = 2,
    this.retryBackoffBase = const Duration(milliseconds: 400),
    this.onRequest,
    this.onResponse,
  });

  factory LencoConfig.sandbox({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v2,
    bool debugMode = true,
    String? baseUrlOverride,
    void Function(String message)? logger,
    int maxRetries = 2,
    Duration retryBackoffBase = const Duration(milliseconds: 400),
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
    })?
    onRequest,
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      required int statusCode,
      required Map<String, dynamic> json,
    })?
    onResponse,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: baseUrlOverride ?? 'https://sandbox-api.lenco.co',
      version: version,
      debugMode: debugMode,
      logger: logger,
      maxRetries: maxRetries,
      retryBackoffBase: retryBackoffBase,
      onRequest: onRequest,
      onResponse: onResponse,
    );
  }

  factory LencoConfig.production({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v2,
    String? baseUrlOverride,
    bool debugMode = false,
    void Function(String message)? logger,
    int maxRetries = 2,
    Duration retryBackoffBase = const Duration(milliseconds: 400),
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
    })?
    onRequest,
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      required int statusCode,
      required Map<String, dynamic> json,
    })?
    onResponse,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: baseUrlOverride ?? 'https://api.lenco.co',
      version: version,
      debugMode: debugMode,
      logger: logger,
      maxRetries: maxRetries,
      retryBackoffBase: retryBackoffBase,
      onRequest: onRequest,
      onResponse: onResponse,
    );
  }

  /// Get the full URL with version path
  String get versionedBaseUrl {
    switch (version) {
      case LencoApiVersion.v1:
        return '$baseUrl/access/v1';
      case LencoApiVersion.v2:
        return '$baseUrl/access/v2';
    }
  }

  /// Copy with method for creating modified configs
  LencoConfig copyWith({
    String? apiKey,
    String? baseUrl,
    LencoApiVersion? version,
    Duration? timeout,
    bool? debugMode,
    void Function(String message)? logger,
    int? maxRetries,
    Duration? retryBackoffBase,
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters,
    })?
    onRequest,
    FutureOr<void> Function({
      required String method,
      required String endpoint,
      required int statusCode,
      required Map<String, dynamic> json,
    })?
    onResponse,
  }) {
    return LencoConfig(
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      version: version ?? this.version,
      timeout: timeout ?? this.timeout,
      debugMode: debugMode ?? this.debugMode,
      logger: logger ?? this.logger,
      maxRetries: maxRetries ?? this.maxRetries,
      retryBackoffBase: retryBackoffBase ?? this.retryBackoffBase,
      onRequest: onRequest ?? this.onRequest,
      onResponse: onResponse ?? this.onResponse,
    );
  }

  @override
  String toString() {
    return 'LencoConfig(baseUrl: $baseUrl, version: $version, debugMode: $debugMode)';
  }
}

/// Lenco API versions
enum LencoApiVersion {
  v1,
  v2;

  String get path {
    switch (this) {
      case LencoApiVersion.v1:
        return 'v1';
      case LencoApiVersion.v2:
        return 'v2';
    }
  }
}
