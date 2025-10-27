import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for transaction-related operations
class TransactionService {
  final LencoHttpClient _client;

  TransactionService(this._client);

  /// Get transactions with optional filters
  Future<List<LencoTransaction>> getTransactions({
    required String accountId,
    int page = 1,
    int limit = 50,
    String? startDate,
    String? endDate,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (type != null) 'type': type,
    };

    final response = await _client.get(
      'accounts/$accountId/transactions',
      queryParameters: queryParams,
    );

    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!
        .map((json) => LencoTransaction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get transaction by ID
  Future<LencoTransaction> getTransactionById({
    required String accountId,
    required String transactionId,
  }) async {
    final response = await _client.get(
      'accounts/$accountId/transactions/$transactionId',
    );

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return LencoTransaction.fromJson(apiResponse.data!);
  }

  /// Get transaction by reference number
  Future<LencoTransaction> getTransactionByReference({
    required String reference,
  }) async {
    final response = await _client.get('transactions/reference/$reference');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return LencoTransaction.fromJson(apiResponse.data!);
  }

  /// Download statement in specified format
  Future<String> downloadStatement({
    required String accountId,
    required String startDate,
    required String endDate,
    String format = 'pdf',
  }) async {
    final queryParams = {
      'startDate': startDate,
      'endDate': endDate,
      'format': format,
    };

    final response = await _client.get(
      'accounts/$accountId/statement',
      queryParameters: queryParams,
    );

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!['downloadUrl'] as String;
  }
}
