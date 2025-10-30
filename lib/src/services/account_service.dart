import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for account-related operations
class AccountService {
  final LencoHttpClient _client;

  AccountService(this._client);

  /// Get all accounts for this API key
  Future<List<LencoAccount>> getAccounts() async {
    final response = await _client.get('accounts');

    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!
        .map((json) => LencoAccount.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get account by ID
  Future<LencoAccount> getAccountById(String accountId) async {
    final response = await _client.get('accounts/$accountId');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return LencoAccount.fromJson(apiResponse.data!);
  }

  /// Get balance info for an account
  Future<Map<String, dynamic>> getAccountBalance(String accountId) async {
    final response = await _client.get('accounts/$accountId/balance');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!;
  }
}
