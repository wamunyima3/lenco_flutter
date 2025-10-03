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

  const LencoConfig({
    required this.apiKey,
    this.baseUrl = 'https://api.lenco.co',
    this.version = LencoApiVersion.v1,
    this.timeout = const Duration(seconds: 30),
    this.debugMode = false,
  });

  /// Create config for sandbox environment
  factory LencoConfig.sandbox({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
    bool debugMode = true,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: 'https://sandbox-api.lenco.co',
      version: version,
      debugMode: debugMode,
    );
  }

  /// Create config for production environment
  factory LencoConfig.production({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
  }) {
    return LencoConfig(
      apiKey: apiKey,
      baseUrl: 'https://api.lenco.co',
      version: version,
      debugMode: false,
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
  }) {
    return LencoConfig(
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      version: version ?? this.version,
      timeout: timeout ?? this.timeout,
      debugMode: debugMode ?? this.debugMode,
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
