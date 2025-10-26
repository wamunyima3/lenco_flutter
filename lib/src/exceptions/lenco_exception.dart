/// Base exception class for Lenco API errors
class LencoException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const LencoException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('LencoException: $message');
    if (statusCode != null) buffer.write(' (Status: $statusCode)');
    if (errorCode != null) buffer.write(' (Code: $errorCode)');
    return buffer.toString();
  }
}

/// Authentication error (401)
class LencoAuthenticationException extends LencoException {
  const LencoAuthenticationException({
    super.message = 'Authentication failed. Check your API key.',
    super.statusCode = 401,
    super.errorCode,
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
  });
}

/// Server error (500+)
class LencoServerException extends LencoException {
  const LencoServerException({
    super.message = 'Server error occurred. Please try again later.',
    super.statusCode,
    super.errorCode,
  });
}

/// Network error (timeout, no connection)
class LencoNetworkException extends LencoException {
  const LencoNetworkException({
    super.message = 'Network error. Check your connection.',
    super.originalError,
  });
}

/// Rate limit exceeded
class LencoRateLimitException extends LencoException {
  const LencoRateLimitException({
    super.message = 'Rate limit exceeded. Please try again later.',
    super.statusCode = 429,
  });
}

/// Unknown error
class LencoUnknownException extends LencoException {
  const LencoUnknownException({
    super.message = 'An unknown error occurred.',
    super.originalError,
    super.stackTrace,
  });
}
