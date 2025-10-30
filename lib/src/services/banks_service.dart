import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Banks lookup (v2)
class BanksService {
  final LencoHttpClient _client;

  BanksService(this._client);

  /// Get supported banks
  Future<List<Bank>> getBanks() async {
    final response = await _client.get('banks');

    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!
        .map((e) => Bank.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
