import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for recipient management - API v1
class RecipientService {
  final LencoHttpClient _client;

  RecipientService(this._client);

  /// Get all recipients
  ///
  /// Example:
  /// ```dart
  /// final recipients = await lenco.recipients.getRecipients();
  /// ```
  Future<List<Recipient>> getRecipients() async {
    final response = await _client.get('recipients');

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

  /// Get recipient by ID
  Future<Recipient> getRecipientById(String recipientId) async {
    final response = await _client.get('recipient/$recipientId');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return Recipient.fromJson(apiResponse.data!);
  }

  /// Create a new recipient
  ///
  /// Example:
  /// ```dart
  /// final recipient = await lenco.recipients.createRecipient(
  ///   accountName: 'John Doe',
  ///   accountNumber: '1234567890',
  ///   bankCode: '044',
  /// );
  /// ```
  Future<Recipient> createRecipient({
    required String accountName,
    required String accountNumber,
    required String bankCode,
  }) async {
    final body = {
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };

    final response = await _client.post('recipients', body: body);

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
