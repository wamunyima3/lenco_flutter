import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';

/// v2 Resolve service
class ResolveServiceV2 {
  final HttpClientV2 _client;

  ResolveServiceV2(this._client);

  Future<Map<String, dynamic>> bankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    if (accountNumber.isEmpty) throw ArgumentError('accountNumber required');
    if (bankCode.isEmpty) throw ArgumentError('bankCode required');
    final body = {'accountNumber': accountNumber, 'bankCode': bankCode};
    final response = await _client.post(
      Endpoints.resolveBankAccount,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  Future<Map<String, dynamic>> mobileMoney({
    required String phone,
    required String operator,
    String country = 'ZM',
  }) async {
    if (operator.isEmpty) throw ArgumentError('operator required');
    final normalizedPhone = MsisdnUtils.toMsisdn(phone);
    final normalizedOperator = operator.toLowerCase();
    final body = {
      'phone': normalizedPhone,
      'operator': normalizedOperator,
      'country': country,
    };
    final response = await _client.post(
      Endpoints.resolveMobileMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  Future<Map<String, dynamic>> lencoMoney({
    required String accountNumber,
  }) async {
    if (accountNumber.isEmpty) throw ArgumentError('accountNumber required');
    final body = {'accountNumber': accountNumber};
    final response = await _client.post(
      Endpoints.resolveLencoMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  Future<Map<String, dynamic>> lencoMerchant({
    required String merchantId,
  }) async {
    if (merchantId.isEmpty) throw ArgumentError('merchantId required');
    final body = {'merchantId': merchantId};
    final response = await _client.post(
      Endpoints.resolveLencoMerchant,
      body: body,
    );
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
