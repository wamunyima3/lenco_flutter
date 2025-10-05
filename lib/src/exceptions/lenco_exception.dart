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
    String message = 'Authentication failed. Check your API key.',
    int statusCode = 401,
    String? errorCode,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
}

/// Validation error (400)
class LencoValidationException extends LencoException {
  final Map<String, dynamic>? errors;

  const LencoValidationException({
    String message = 'Validation error occurred.',
    int statusCode = 400,
    String? errorCode,
    this.errors,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );

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
    String message = 'Resource not found.',
    int statusCode = 404,
    String? errorCode,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
}

/// Server error (500+)
class LencoServerException extends LencoException {
  const LencoServerException({
    String message = 'Server error occurred. Please try again later.',
    int? statusCode,
    String? errorCode,
  }) : super(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
}

/// Network error (timeout, no connection)
class LencoNetworkException extends LencoException {
  const LencoNetworkException({
    String message = 'Network error. Check your connection.',
    dynamic originalError,
  }) : super(
          message: message,
          originalError: originalError,
        );
}

/// Rate limit exceeded
class LencoRateLimitException extends LencoException {
  const LencoRateLimitException({
    String message = 'Rate limit exceeded. Please try again later.',
    int statusCode = 429,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}

/// Unknown error
class LencoUnknownException extends LencoException {
  const LencoUnknownException({
    String message = 'An unknown error occurred.',
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
          message: message,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}
