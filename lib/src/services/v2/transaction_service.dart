import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// v2 Transaction service
class TransactionServiceV2 {
  final HttpClientV2 _client;

  TransactionServiceV2(this._client);

  Future<List<LencoTransaction>> getTransactions({
    int page = 1,
    int limit = 50,
    String? startDate,
    String? endDate,
    String? type,
  }) async {
    if (page < 1) throw ArgumentError.value(page, 'page', 'Must be >= 1');
    if (limit < 1) throw ArgumentError.value(limit, 'limit', 'Must be >= 1');
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
      if (type != null) 'type': type,
    };
    final response = await _client.get(
      Endpoints.transactions,
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

  Future<LencoTransaction> getTransactionById(String id) async {
    if (id.isEmpty) throw ArgumentError('id required');
    final response = await _client.get('${Endpoints.transactions}/$id');
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return LencoTransaction.fromJson(apiResponse.data!);
  }
}
