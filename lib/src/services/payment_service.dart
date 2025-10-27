import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for payment-related operations
class PaymentService {
  final LencoHttpClient _client;

  PaymentService(this._client);

  /// Initiate a bank transfer
  ///
  /// [request] - Payment request details
  ///
  /// Example:
  /// ```dart
  /// final payment = await lenco.payments.initiatePayment(
  ///   PaymentRequest(
  ///     accountId: 'account-id',
  ///     amount: '10000',
  ///     recipientAccountNumber: '1234567890',
  ///     recipientBankCode: '044',
  ///     narration: 'Payment for services',
  ///   ),
  /// );
  /// ```
  Future<PaymentResponse> initiatePayment(PaymentRequest request) async {
    final response = await _client.post(
      'payments/transfer',
      body: request.toJson(),
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

  /// Verify account name before transfer
  Future<String> verifyAccountName({
    required String accountNumber,
    required String bankCode,
  }) async {
    final queryParams = {'accountNumber': accountNumber, 'bankCode': bankCode};

    final response = await _client.get(
      'payments/verify-account',
      queryParameters: queryParams,
    );

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!['accountName'] as String;
  }

  /// Get list of supported banks
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
        .map((json) => Bank.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Check payment status by reference
  Future<PaymentResponse> getPaymentStatus({required String reference}) async {
    final response = await _client.get('payments/$reference');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return PaymentResponse.fromJson(apiResponse.data!);
  }

  /// Transfer to multiple recipients at once
  Future<Map<String, dynamic>> initiateBulkTransfer({
    required String accountId,
    required List<PaymentRequest> transfers,
  }) async {
    final body = {
      'accountId': accountId,
      'transfers': transfers.map((t) => t.toJson()).toList(),
    };

    final response = await _client.post('payments/bulk-transfer', body: body);

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!;
  }

  /// Calculate transfer fee
  Future<String> getTransferFee({
    required String amount,
    required String bankCode,
  }) async {
    final queryParams = {'amount': amount, 'bankCode': bankCode};

    final response = await _client.get(
      'payments/fee',
      queryParameters: queryParams,
    );

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return apiResponse.data!['fee'] as String;
  }
}
