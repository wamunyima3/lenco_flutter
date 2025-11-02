import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';

/// v2 Settlements service
class SettlementsServiceV2 {
  final HttpClientV2 _client;

  SettlementsServiceV2(this._client);

  Future<List<Settlement>> getSettlements({
    int page = 1,
    int limit = 50,
    String? status,
  }) async {
    if (page < 1) throw ArgumentError.value(page, 'page', 'Must be >= 1');
    if (limit < 1) throw ArgumentError.value(limit, 'limit', 'Must be >= 1');
    final response = await _client.get(
      Endpoints.settlements,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
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
        .map((json) => Settlement.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Settlement> getSettlementById(String settlementId) async {
    if (settlementId.isEmpty) {
      throw ArgumentError.value(
        settlementId,
        'settlementId',
        'Must not be empty',
      );
    }
    final response = await _client.get(
      '${Endpoints.settlements}/$settlementId',
    );
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
