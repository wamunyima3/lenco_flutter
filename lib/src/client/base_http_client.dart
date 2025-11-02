import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lenco_flutter/src/config/lenco_config.dart';
import 'package:lenco_flutter/src/exceptions/lenco_exception.dart';
import 'package:lenco_flutter/src/core/platform_exceptions.dart';

/// Base HTTP client that handles common concerns: timeouts, errors, logging.
abstract class BaseHttpClient {
  final LencoConfig config;
  final http.Client _client;

  BaseHttpClient({required this.config, http.Client? client})
    : _client = client ?? http.Client();

  /// Implement in subclasses to return the versioned base URL
  String get baseUrl;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${config.apiKey}',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void _debugLog(String message) {
    if (config.debugMode) {
      if (config.logger != null) {
        config.logger!.call('[Lenco] $message');
      } else {
        // ignore: avoid_print
        print('[Lenco] $message');
      }
    }
  }

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

  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final path = '$baseUrl/$endpoint';
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final cleanParams = queryParameters.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
      return Uri.parse(path).replace(queryParameters: cleanParams);
    }
    return Uri.parse(path);
  }

  Map<String, dynamic> _parseJsonBody(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw LencoException(
        message: 'Failed to parse response: ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  Map<String, dynamic> _handleResponse({
    required http.Response response,
    required String method,
    required String endpoint,
  }) {
    final statusCode = response.statusCode;
    final responseBody = _parseJsonBody(response);

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    }

    final message = responseBody['message'] as String? ?? 'Unknown error';
    final errorCode = responseBody['errorCode'] as String?;
    final errors = responseBody['errors'] as Map<String, dynamic>?;
    final requestId =
        response.headers['x-request-id'] ??
        response.headers['x-requestid'] ??
        response.headers['request-id'];

    switch (statusCode) {
      case 400:
      case 422:
        throw LencoValidationException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          errors: errors,
          method: method,
          endpoint: endpoint,
          requestId: requestId,
        );
      case 401:
        throw LencoAuthenticationException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          method: method,
          endpoint: endpoint,
          requestId: requestId,
        );
      case 404:
        throw LencoNotFoundException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          method: method,
          endpoint: endpoint,
          requestId: requestId,
        );
      case 429:
        throw LencoRateLimitException(
          method: method,
          endpoint: endpoint,
          requestId: requestId,
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
          method: method,
          endpoint: endpoint,
          requestId: requestId,
        );
      default:
        throw LencoException(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          method: method,
          endpoint: endpoint,
          requestId: requestId,
        );
    }
  }

  Future<Map<String, dynamic>> _makeRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    // Interceptor: onRequest
    if (config.onRequest != null) {
      await config.onRequest!.call(
        method: method,
        endpoint: endpoint,
        body: body,
        queryParameters: queryParameters,
      );
    }

    final uri = _buildUri(endpoint, queryParameters);

    if (config.debugMode) {
      _debugLog('$method $uri');
      if (body != null) _debugLog('Body: ${jsonEncode(body)}');
    }

    int attempt = 0;
    while (true) {
      try {
        final http.Response response;
        switch (method) {
          case 'GET':
            response = await _client
                .get(uri, headers: _headers)
                .timeout(config.timeout);
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
          _debugLog('Response: ${response.statusCode}');
          _debugLog('Body: ${response.body}');
        }

        final json = _handleResponse(
          response: response,
          method: method,
          endpoint: endpoint,
        );

        // Interceptor: onResponse
        if (config.onResponse != null) {
          await config.onResponse!.call(
            method: method,
            endpoint: endpoint,
            statusCode: response.statusCode,
            json: json,
          );
        }

        return json;
      } on LencoRateLimitException catch (_) {
        if (attempt >= config.maxRetries) rethrow;
        attempt += 1;
        final backoff = config.retryBackoffBase * attempt;
        await Future<void>.delayed(backoff);
        continue;
      } on LencoServerException catch (_) {
        if (attempt >= config.maxRetries) rethrow;
        attempt += 1;
        final backoff = config.retryBackoffBase * attempt;
        await Future<void>.delayed(backoff);
        continue;
      } on TimeoutException catch (_) {
        if (attempt >= config.maxRetries) {
          throw const LencoNetworkException(
            message: 'Request timed out. Please try again.',
          );
        }
        attempt += 1;
        final backoff = config.retryBackoffBase * attempt;
        await Future<void>.delayed(backoff);
        continue;
      } on SocketException catch (e) {
        if (attempt >= config.maxRetries) {
          throw LencoNetworkException(
            message: 'Network error: ${e.message}',
            originalError: e,
            method: method,
            endpoint: endpoint,
          );
        }
        attempt += 1;
        final backoff = config.retryBackoffBase * attempt;
        await Future<void>.delayed(backoff);
        continue;
      } on http.ClientException catch (e) {
        // ClientExceptions are usually not retriable; bubble up immediately
        throw LencoNetworkException(
          message: 'HTTP client error: ${e.message}',
          originalError: e,
          method: method,
          endpoint: endpoint,
        );
      } on LencoException {
        // Validation/auth/not-found aren't retriable
        rethrow;
      } catch (e, stackTrace) {
        throw LencoUnknownException(
          message: 'Unexpected error: ${e.toString()}',
          originalError: e,
          stackTrace: stackTrace,
          method: method,
          endpoint: endpoint,
        );
      }
    }
  }

  void close() {
    _client.close();
  }
}
