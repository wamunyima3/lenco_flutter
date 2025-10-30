import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class EncryptionService {
  final LencoHttpClient _client;

  EncryptionService(this._client);

  /// Fetch the API encryption key
  Future<String> getEncryptionKey() async {
    final response = await _client.get('encryption-key');
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!['key'] as String;
  }
}
