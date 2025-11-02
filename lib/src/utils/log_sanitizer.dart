/// Utilities for sanitizing sensitive data in logs
class LogSanitizer {
  LogSanitizer._();

  /// Sanitize a JSON body by redacting sensitive fields
  ///
  /// Fields redacted: cardNumber, cvv, accountNumber, phone, apiKey, merchantId
  ///
  /// Example:
  /// ```dart
  /// final sanitized = LogSanitizer.sanitizeBody({
  ///   'cardNumber': '4532015112830366',
  ///   'cvv': '123',
  ///   'amount': '10000',
  /// });
  /// // Result: {'cardNumber': '***', 'cvv': '***', 'amount': '10000'}
  /// ```
  static Map<String, dynamic> sanitizeBody(Map<String, dynamic> body) {
    final sensitiveFields = [
      'cardNumber',
      'cvv',
      'accountNumber',
      'phone',
      'apiKey',
      'merchantId',
      'bvn',
    ];

    final sanitized = <String, dynamic>{};
    for (final entry in body.entries) {
      if (sensitiveFields.contains(entry.key)) {
        sanitized[entry.key] = '***';
      } else if (entry.value is Map<String, dynamic>) {
        sanitized[entry.key] = sanitizeBody(
          entry.value as Map<String, dynamic>,
        );
      } else {
        sanitized[entry.key] = entry.value;
      }
    }
    return sanitized;
  }

  /// Sanitize a log message by replacing API keys and sensitive tokens
  ///
  /// Replaces patterns like "Bearer <key>" with "Bearer ***"
  static String sanitizeMessage(String message) {
    return message.replaceAllMapped(
      RegExp(r'Bearer\s+[\w-]+', caseSensitive: false),
      (match) => 'Bearer ***',
    );
  }
}
