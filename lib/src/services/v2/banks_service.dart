import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/utils/simple_cache.dart';

/// v2 Banks service
class BanksServiceV2 {
  final HttpClientV2 _client;

  // Cache bank list for 1 hour (banks change infrequently)
  static final _cache = SimpleCache<List<Bank>>(ttl: const Duration(hours: 1));

  BanksServiceV2(this._client);

  /// Get list of supported banks (cached for 1 hour)
  Future<List<Bank>> getBanks({bool forceRefresh = false}) async {
    // Return cached value if available and not forcing refresh
    if (!forceRefresh) {
      final cached = _cache.value;
      if (cached != null) return cached;
    }

    final response = await _client.get(Endpoints.banks);
    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    final banks = apiResponse.data!
        .map((e) => Bank.fromJson(e as Map<String, dynamic>))
        .toList();

    // Cache the result
    _cache.set(banks);

    return banks;
  }

  /// Clear the bank list cache
  static void clearCache() {
    _cache.clear();
  }
}
