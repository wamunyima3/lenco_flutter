import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for transaction-related operations
class TransactionService {
  final LencoHttpClient _client;

  TransactionService(this._client);

  /// Get all transactions for an account
  ///
  /// [accountId] - The unique identifier of the account
  /// [page] - Page number for pagination (default: 1)
  /// [limit] - Number of transactions per page (default: 50)
  /// [startDate] - Filter transactions from this date (ISO 8601 format)
  /// [endDate] - Filter transactions until this date (ISO 8601 format)
  /// [type] - Filter by transaction type (credit, debit)
  ///
  /// Example:
  /// ```dart
  /// final transactions = await lenco.transactions.getTransactions(
  ///   accountId: 'account-id',
  ///   limit: 20,
  ///   type: 'credit',
  /// );
  /// ```
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

  /// Get a specific transaction by ID
  ///
  /// [accountId] - The unique identifier of the account
  /// [transactionId] - The unique identifier of the transaction
  ///
  /// Example:
  /// ```dart
  /// final transaction = await lenco.transactions.getTransactionById(
  ///   accountId: 'account-id',
  ///   transactionId: 'txn-id',
  /// );
  /// ```
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

  /// Get transaction by reference
  ///
  /// [reference] - The transaction reference
  ///
  /// Example:
  /// ```dart
  /// final transaction = await lenco.transactions.getTransactionByReference(
  ///   reference: 'TXN-REF-123',
  /// );
  /// ```
  Future<LencoTransaction> getTransactionByReference({
    required String reference,
  }) async {
    final response = await _client.get(
      'transactions/reference/$reference',
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

  /// Download transaction statement
  ///
  /// [accountId] - The unique identifier of the account
  /// [startDate] - Start date for statement (ISO 8601 format)
  /// [endDate] - End date for statement (ISO 8601 format)
  /// [format] - Format of the statement (pdf, csv, xlsx)
  ///
  /// Returns the URL to download the statement
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
