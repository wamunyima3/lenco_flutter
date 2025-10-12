import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for account-related operations
class AccountService {
  final LencoHttpClient _client;

  AccountService(this._client);

  /// Get all accounts
  ///
  /// Returns a list of all accounts associated with the API key.
  ///
  /// Example:
  /// ```dart
  /// final accounts = await lenco.accounts.getAccounts();
  /// for (var account in accounts) {
  ///   print('${account.name}: ${account.currentBalance}');
  /// }
  /// ```
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

  /// Get a specific account by ID
  ///
  /// [accountId] - The unique identifier of the account
  ///
  /// Example:
  /// ```dart
  /// final account = await lenco.accounts.getAccountById('account-id');
  /// print('Balance: ${account.availableBalance}');
  /// ```
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

  /// Get account balance
  ///
  /// [accountId] - The unique identifier of the account
  ///
  /// Returns a map with 'available' and 'current' balance
  Future<Map<String, String>> getAccountBalance(String accountId) async {
    final account = await getAccountById(accountId);
    return {
      'available': account.availableBalance,
      'current': account.currentBalance,
      'currency': account.currency,
    };
  }
}
