import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';

/// v2 Payments/Transfers service
class PaymentServiceV2 {
  final HttpClientV2 _client;

  PaymentServiceV2(this._client);

  Future<PaymentResponse> transferToBankAccount({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String recipientAccountNumber,
    required String recipientBankCode,
    String? narration,
  }) async {
    final body = {
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'recipientAccountNumber': recipientAccountNumber,
      'recipientBankCode': recipientBankCode,
      if (narration != null) 'narration': narration,
    };
    final response = await _client.post(
      Endpoints.transferBankAccount,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<PaymentResponse> transferToMobileMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String phone,
    required String operator,
    String country = 'ZM',
    String? narration,
  }) async {
    final normalizedPhone = MsisdnUtils.toMsisdn(phone);
    final normalizedOperator = operator.toLowerCase();
    final body = {
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'phone': normalizedPhone,
      'operator': normalizedOperator,
      'country': country,
      if (narration != null) 'narration': narration,
    };
    final response = await _client.post(
      Endpoints.transferMobileMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<PaymentResponse> transferToLencoMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String accountNumber,
    String? narration,
  }) async {
    final body = {
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'accountNumber': accountNumber,
      if (narration != null) 'narration': narration,
    };
    final response = await _client.post(
      Endpoints.transferLencoMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<PaymentResponse> transferToLencoMerchant({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String merchantId,
    String? narration,
  }) async {
    final body = {
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'merchantId': merchantId,
      if (narration != null) 'narration': narration,
    };
    final response = await _client.post(
      Endpoints.transferLencoMerchant,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<PaymentResponse> transferBetweenAccounts({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String toAccountId,
    String? narration,
  }) async {
    final body = {
      'accountId': accountId,
      'amount': amount,
      'currency': currency,
      'reference': reference,
      'toAccountId': toAccountId,
      if (narration != null) 'narration': narration,
    };
    final response = await _client.post(Endpoints.transferAccount, body: body);
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<List<PaymentResponse>> getTransfers({
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _client.get(
      Endpoints.transfers,
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
        .map((e) => PaymentResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaymentResponse> getTransferById(String id) async {
    final response = await _client.get(Endpoints.transferById(id));
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

  Future<PaymentResponse> getTransferStatus(String reference) async {
    final response = await _client.get(Endpoints.transferStatus(reference));
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }
}
