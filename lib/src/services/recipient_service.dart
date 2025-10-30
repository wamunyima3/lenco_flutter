import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for transfer recipient management - API v2
class RecipientService {
  final LencoHttpClient _client;

  RecipientService(this._client);

  /// Get all transfer recipients
  ///
  /// Example:
  /// ```dart
  /// final recipients = await lenco.recipients.getRecipients();
  /// ```
  Future<List<Recipient>> getRecipients() async {
    final response = await _client.get('transfer-recipients');

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

  /// Get transfer recipient by ID
  Future<Recipient> getRecipientById(String recipientId) async {
    final response = await _client.get('transfer-recipients/$recipientId');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return Recipient.fromJson(apiResponse.data!);
  }

  /// Create bank account transfer recipient
  ///
  /// Example:
  /// ```dart
  /// final recipient = await lenco.recipients.createRecipient(
  ///   accountName: 'John Doe',
  ///   accountNumber: '1234567890',
  ///   bankCode: '044',
  /// );
  /// ```
  Future<Recipient> createBankAccountRecipient({
    required String accountName,
    required String accountNumber,
    required String bankCode,
  }) async {
    final body = {
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };

    final response = await _client.post(
      'transfer-recipients/bank-account',
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

  /// Create mobile money transfer recipient
  Future<Recipient> createMobileMoneyRecipient({
    required String name,
    required String phone,
    required String operator,
    String country = 'ZM',
  }) async {
    final body = {
      'name': name,
      'phone': phone,
      'operator': operator,
      'country': country,
    };

    final response = await _client.post(
      'transfer-recipients/mobile-money',
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

  /// Create lenco money transfer recipient
  Future<Recipient> createLencoMoneyRecipient({
    required String name,
    required String accountNumber,
  }) async {
    final body = {'name': name, 'accountNumber': accountNumber};

    final response = await _client.post(
      'transfer-recipients/lenco-money',
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

  /// Create lenco merchant transfer recipient
  Future<Recipient> createLencoMerchantRecipient({
    required String name,
    required String merchantId,
  }) async {
    final body = {'name': name, 'merchantId': merchantId};

    final response = await _client.post(
      'transfer-recipients/lenco-merchant',
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
