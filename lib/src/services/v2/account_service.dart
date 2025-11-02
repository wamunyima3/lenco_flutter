import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// v2 Account service
class AccountServiceV2 {
  final HttpClientV2 _client;

  AccountServiceV2(this._client);

  Future<List<LencoAccount>> getAccounts() async {
    final response = await _client.get(Endpoints.accounts);
    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    try {
      return apiResponse.data!
          .map((json) => LencoAccount.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Log debug info if logger is available and debug mode is enabled
      if (apiResponse.data!.isNotEmpty && _client.config.debugMode) {
        _client.config.logger?.call(
          'First account data: ${apiResponse.data![0]}',
        );
      }
      rethrow;
    }
  }

  Future<LencoAccount> getAccountById(String accountId) async {
    final response = await _client.get(Endpoints.accountById(accountId));
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
    final response = await _client.get(Endpoints.accountBalance(accountId));
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
