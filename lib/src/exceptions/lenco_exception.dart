/// Base exception class for Lenco API errors
class LencoException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic originalError;
  final StackTrace? stackTrace;
  // Request context
  final String? method; // GET, POST, ...
  final String? endpoint; // e.g., accounts/123
  final String? requestId; // from response headers if available

  const LencoException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.originalError,
    this.stackTrace,
    this.method,
    this.endpoint,
    this.requestId,
  });

  @override
  String toString() {
    final buffer = StringBuffer('LencoException: $message');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    if (errorCode != null) buffer.write(' (Code: $errorCode)');
    if (method != null) buffer.write(' [Method: $method]');
    if (endpoint != null) buffer.write(' [Endpoint: $endpoint]');
    if (requestId != null) buffer.write(' [RequestId: $requestId]');
    return buffer.toString();
  }
}

/// Authentication error (401)
class LencoAuthenticationException extends LencoException {
  const LencoAuthenticationException({
    super.message = 'Authentication failed. Check your API key.',
    super.statusCode = 401,
    super.errorCode,
    super.method,
    super.endpoint,
    super.requestId,
  });
}

/// Validation error (400)
class LencoValidationException extends LencoException {
  final Map<String, dynamic>? errors;

  const LencoValidationException({
    super.message = 'Validation error occurred.',
    super.statusCode = 400,
    super.errorCode,
    this.errors,
    super.method,
    super.endpoint,
    super.requestId,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (errors != null && errors!.isNotEmpty) {
      buffer.write('\nValidation errors: ${errors.toString()}');
    }
    return buffer.toString();
  }
}

/// Resource not found error (404)
class LencoNotFoundException extends LencoException {
  const LencoNotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
    super.errorCode,
    super.method,
    super.endpoint,
    super.requestId,
  });
}

/// Server error (500+)
class LencoServerException extends LencoException {
  const LencoServerException({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode,
    super.errorCode,
    super.method,
    super.endpoint,
    super.requestId,
  });
}

/// Network error (timeout, no connection)
class LencoNetworkException extends LencoException {
  const LencoNetworkException({
    super.message = 'Network error. Check your connection.',
    super.originalError,
    super.method,
    super.endpoint,
    super.requestId,
  });
}

/// Rate limit exceeded
class LencoRateLimitException extends LencoException {
  const LencoRateLimitException({
    super.message = 'Rate limit exceeded. Please try again later.',
    super.statusCode = 429,
    super.method,
    super.endpoint,
    super.requestId,
  });
}

/// Unknown error
class LencoUnknownException extends LencoException {
  const LencoUnknownException({
    super.message = 'An unknown error occurred.',
    super.originalError,
    super.stackTrace,
    super.method,
    super.endpoint,
    super.requestId,
  });
}
