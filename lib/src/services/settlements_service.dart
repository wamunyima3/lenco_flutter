import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for settlement management - API v2
class SettlementsService {
  final LencoHttpClient _client;

  SettlementsService(this._client);

  /// Get all settlements
  ///
  /// Example:
  /// ```dart
  /// final settlements = await lenco.settlements.getSettlements(
  ///   page: 1,
  ///   limit: 20,
  /// );
  /// ```
  Future<List<Settlement>> getSettlements({
    int page = 1,
    int limit = 50,
    String? status,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    };

    final response = await _client.get(
      'settlements',
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
        .map((json) => Settlement.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get settlement by ID
  Future<Settlement> getSettlementById(String settlementId) async {
    final response = await _client.get('settlements/$settlementId');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return Settlement.fromJson(apiResponse.data!);
  }
}
