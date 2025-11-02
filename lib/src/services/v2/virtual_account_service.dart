import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// v2 Virtual accounts service (if supported similarly in v2)
class VirtualAccountServiceV2 {
  final HttpClientV2 _client;

  VirtualAccountServiceV2(this._client);

  Future<List<VirtualAccount>> getVirtualAccounts({
    int page = 1,
    int limit = 50,
  }) async {
    if (page < 1) throw ArgumentError.value(page, 'page', 'Must be >= 1');
    if (limit < 1) throw ArgumentError.value(limit, 'limit', 'Must be >= 1');
    final response = await _client.get(
      Endpoints.virtualAccounts,
      queryParameters: {'page': page, 'limit': limit},
    );
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

  Future<VirtualAccount> getVirtualAccountByReference(
    String accountReference,
  ) async {
    final response = await _client.get(
      Endpoints.virtualAccountByReference(accountReference),
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return VirtualAccount.fromJson(apiResponse.data!);
  }

  Future<List<LencoTransaction>> getTransactions({
    String? accountReference,
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _client.get(
      Endpoints.virtualAccountTransactions,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (accountReference != null) 'accountReference': accountReference,
      },
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
