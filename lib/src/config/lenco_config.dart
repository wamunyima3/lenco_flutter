/// Configuration class for Lenco API
class LencoConfig {
  /// API key for authentication
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

  const LencoConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.lenco.co',
    this.version = LencoApiVersion.v1,
    this.timeout = const Duration(seconds: 30),
    this.debugMode = false,
    this.logger,
  });

  factory LencoConfig.sandbox({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
    bool debugMode = true,
    String? baseUrlOverride,
    void Function(String message)? logger,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: baseUrlOverride ?? 'https://sandbox-api.lenco.co',
      version: version,
      debugMode: debugMode,
      logger: logger,
    );
  }

  factory LencoConfig.production({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
    String? baseUrlOverride,
    void Function(String message)? logger,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: baseUrlOverride ?? 'https://api.lenco.co',
      version: version,
      debugMode: false,
      logger: logger,
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
  }) {
    return LencoConfig(
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      version: version ?? this.version,
      timeout: timeout ?? this.timeout,
      debugMode: debugMode ?? this.debugMode,
      logger: logger ?? this.logger,
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
