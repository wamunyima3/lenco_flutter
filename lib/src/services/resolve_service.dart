import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Resolve endpoints (v2)
class ResolveService {
  final LencoHttpClient _client;

  ResolveService(this._client);

  /// Resolve bank account name/owner details
  Future<Map<String, dynamic>> bankAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    final body = {'accountNumber': accountNumber, 'bankCode': bankCode};

    final response = await _client.post('resolve/bank-account', body: body);
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  /// Resolve mobile money (owner) details
  Future<Map<String, dynamic>> mobileMoney({
    required String phone,
    required String operator,
    String country = 'ZM',
  }) async {
    final normalizedPhone = MsisdnUtils.toMsisdn(phone);
    final normalizedOperator = operator.toLowerCase();
    final body = {
      'phone': normalizedPhone,
      'operator': normalizedOperator,
      'country': country,
    };

    final response = await _client.post('resolve/mobile-money', body: body);
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  /// Resolve lenco-money
  Future<Map<String, dynamic>> lencoMoney({
    required String accountNumber,
  }) async {
    final body = {'accountNumber': accountNumber};
    final response = await _client.post('resolve/lenco-money', body: body);
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!;
  }

  /// Resolve lenco-merchant
  Future<Map<String, dynamic>> lencoMerchant({
    required String merchantId,
  }) async {
    final body = {'merchantId': merchantId};
    final response = await _client.post('resolve/lenco-merchant', body: body);
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
