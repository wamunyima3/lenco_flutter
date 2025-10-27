import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for virtual account operations - API v1
class VirtualAccountService {
  final LencoHttpClient _client;

  VirtualAccountService(this._client);

  /// Create a new virtual account
  ///
  /// Example:
  /// ```dart
  /// final virtualAccount = await lenco.virtualAccounts.createVirtualAccount(
  ///   accountName: 'John Doe',
  ///   bvn: '12345678901',
  /// );
  /// ```
  Future<VirtualAccount> createVirtualAccount({
    required String accountName,
    String? bvn,
  }) async {
    final body = {'accountName': accountName, if (bvn != null) 'bvn': bvn};

    final response = await _client.post('virtual-accounts', body: body);

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return VirtualAccount.fromJson(apiResponse.data!);
  }

  /// Get all virtual accounts
  ///
  /// Example:
  /// ```dart
  /// final accounts = await lenco.virtualAccounts.getVirtualAccounts();
  /// ```
  Future<List<VirtualAccount>> getVirtualAccounts() async {
    final response = await _client.get('virtual-accounts');

    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!
        .map((json) => VirtualAccount.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get virtual account by reference
  Future<VirtualAccount> getVirtualAccountByReference(
    String accountReference,
  ) async {
    final response = await _client.get('virtual-accounts/$accountReference');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return VirtualAccount.fromJson(apiResponse.data!);
  }

  /// Get virtual account by BVN
  Future<VirtualAccount> getVirtualAccountByBvn(String bvn) async {
    final response = await _client.get('virtual-account-by-bvn/$bvn');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return VirtualAccount.fromJson(apiResponse.data!);
  }

  /// Get virtual account transactions
  ///
  /// Example:
  /// ```dart
  /// final transactions = await lenco.virtualAccounts.getTransactions(
  ///   page: 1,
  ///   limit: 50,
  /// );
  /// ```
  Future<List<LencoTransaction>> getTransactions({
    String? accountReference,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (accountReference != null) 'accountReference': accountReference,
    };

    final response = await _client.get(
      'virtual-accounts/transactions',
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

  /// Get virtual account transaction by ID
  Future<LencoTransaction> getTransactionById(String transactionId) async {
    final response = await _client.get(
      'virtual-accounts/transactions/$transactionId',
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

  /// Get rejected virtual account transactions
  Future<List<LencoTransaction>> getRejectedTransactions({
    String? accountReference,
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (accountReference != null) 'accountReference': accountReference,
    };

    final response = await _client.get(
      'virtual-accounts/rejected-transactions',
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

  /// Get rejected transaction by ID
  Future<LencoTransaction> getRejectedTransactionById(
    String transactionId,
  ) async {
    final response = await _client.get(
      'virtual-accounts/rejected-transactions/$transactionId',
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

  /// Get all virtual account transactions
  Future<List<LencoTransaction>> getAllTransactions({
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {'page': page, 'limit': limit};

    final response = await _client.get(
      'virtual-accounts/all-transactions',
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
}
