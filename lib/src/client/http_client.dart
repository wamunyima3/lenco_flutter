import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lenco_flutter/src/config/lenco_config.dart';
import 'package:lenco_flutter/src/exceptions/lenco_exception.dart';

/// HTTP client for making requests to Lenco API
class LencoHttpClient {
  final LencoConfig config;
  final http.Client _client;

  LencoHttpClient({
    required this.config,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Get authorization headers
  Map<String, String> get _headers => {
        'Authorization': 'Bearer ${config.apiKey}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Make GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _makeRequest(
      method: 'GET',
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  /// Make POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _makeRequest(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
    );
  }

  /// Make PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _makeRequest(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      queryParameters: queryParameters,
    );
  }

  /// Make DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _makeRequest(
      method: 'DELETE',
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  /// Core request method
  Future<Map<String, dynamic>> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    if (config.debugMode) {
      print('[Lenco] $method $uri');
      if (body != null) print('[Lenco] Body: ${jsonEncode(body)}');
    }

    try {
      final http.Response response;

      switch (method) {
        case 'GET':
          response =
              await _client.get(uri, headers: _headers).timeout(config.timeout);
          break;
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: _headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(config.timeout);
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: _headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(config.timeout);
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: _headers)
              .timeout(config.timeout);
          break;
        default:
          throw LencoException(message: 'Unsupported HTTP method: $method');
      }

      if (config.debugMode) {
        print('[Lenco] Response: ${response.statusCode}');
        print('[Lenco] Body: ${response.body}');
      }

      return _handleResponse(response);
    } on LencoException {
      // Re-throw Lenco exceptions as-is
      rethrow;
    } on TimeoutException {
      throw const LencoNetworkException(
        message: 'Request timed out. Please try again.',
      );
    } on SocketException catch (e) {
      throw LencoNetworkException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } on http.ClientException catch (e) {
      throw LencoNetworkException(
        message: 'HTTP client error: ${e.message}',
        originalError: e,
      );
    } catch (e, stackTrace) {
      throw LencoUnknownException(
        message: 'Unexpected error: ${e.toString()}',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final path = '${config.versionedBaseUrl}/$endpoint';

    if (queryParameters != null && queryParameters.isNotEmpty) {
      final cleanParams = queryParameters.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
      return Uri.parse(path).replace(queryParameters: cleanParams);
    }

    return Uri.parse(path);
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    Map<String, dynamic> responseBody;

    try {
      responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw LencoException(
        message: 'Failed to parse response: ${response.body}',
        statusCode: statusCode,
      );
    }

    // Success responses (200, 201)
    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    }

    // Extract error information
    final message = responseBody['message'] as String? ?? 'Unknown error';
    final errorCode = responseBody['errorCode'] as String?;
    final errors = responseBody['errors'] as Map<String, dynamic>?;

    // Handle specific error codes
    switch (statusCode) {
      case 400:
        throw LencoValidationException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          errors: errors,
        );
      case 401:
        throw LencoAuthenticationException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
      case 404:
        throw LencoNotFoundException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
      case 429:
        throw LencoRateLimitException(
          message: message,
          statusCode: statusCode,
        );
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        throw LencoServerException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
      default:
        throw LencoException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
        );
    }
  }

  /// Close the HTTP client
  void close() {
    _client.close();
  }
}
