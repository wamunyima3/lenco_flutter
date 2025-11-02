import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';

/// v2 Transfer recipients service
class RecipientServiceV2 {
  final HttpClientV2 _client;

  RecipientServiceV2(this._client);

  Future<List<Recipient>> getRecipients() async {
    final response = await _client.get(Endpoints.transferRecipients);
    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!
        .map((json) => Recipient.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Recipient> getRecipientById(String recipientId) async {
    if (recipientId.isEmpty) {
      throw ArgumentError.value(
        recipientId,
        'recipientId',
        'Must not be empty',
      );
    }
    final response = await _client.get(
      Endpoints.transferRecipientById(recipientId),
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return Recipient.fromJson(apiResponse.data!);
  }

  Future<Recipient> createBankAccountRecipient({
    required String accountName,
    required String accountNumber,
    required String bankCode,
  }) async {
    if (accountName.isEmpty) throw ArgumentError('accountName required');
    if (accountNumber.isEmpty) throw ArgumentError('accountNumber required');
    if (bankCode.isEmpty) throw ArgumentError('bankCode required');
    final body = {
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };
    final response = await _client.post(
      Endpoints.transferRecipientBankAccount,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return Recipient.fromJson(apiResponse.data!);
  }

  Future<Recipient> createMobileMoneyRecipient({
    required String name,
    required String phone,
    required String operator,
    String country = 'ZM',
  }) async {
    if (name.isEmpty) throw ArgumentError('name required');
    if (operator.isEmpty) throw ArgumentError('operator required');
    final msisdn = MsisdnUtils.toMsisdn(phone);
    final normalizedOperator = operator.toLowerCase();
    final body = {
      'name': name,
      'phone': msisdn,
      'operator': normalizedOperator,
      'country': country,
    };
    final response = await _client.post(
      Endpoints.transferRecipientMobileMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return Recipient.fromJson(apiResponse.data!);
  }

  Future<Recipient> createLencoMoneyRecipient({
    required String name,
    required String accountNumber,
  }) async {
    if (name.isEmpty) throw ArgumentError('name required');
    if (accountNumber.isEmpty) throw ArgumentError('accountNumber required');
    final body = {'name': name, 'accountNumber': accountNumber};
    final response = await _client.post(
      Endpoints.transferRecipientLencoMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return Recipient.fromJson(apiResponse.data!);
  }

  Future<Recipient> createLencoMerchantRecipient({
    required String name,
    required String merchantId,
  }) async {
    if (name.isEmpty) throw ArgumentError('name required');
    if (merchantId.isEmpty) throw ArgumentError('merchantId required');
    final body = {'name': name, 'merchantId': merchantId};
    final response = await _client.post(
      Endpoints.transferRecipientLencoMerchant,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return Recipient.fromJson(apiResponse.data!);
  }
}
