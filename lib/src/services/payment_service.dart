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

  /// Verify account name
  ///
  /// [accountNumber] - The account number to verify
  /// [bankCode] - The bank code (e.g., '044' for Access Bank)
  ///
  /// Returns the account name if found
  ///
  /// Example:
  /// ```dart
  /// final accountName = await lenco.payments.verifyAccountName(
  ///   accountNumber: '1234567890',
  ///   bankCode: '044',
  /// );
  /// print('Account Name: $accountName');
  /// ```
  Future<String> verifyAccountName({
    required String accountNumber,
    required String bankCode,
  }) async {
    final queryParams = {
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };

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

  /// Get all Nigerian banks
  ///
  /// Returns a list of all supported banks with their codes
  ///
  /// Example:
  /// ```dart
  /// final banks = await lenco.payments.getBanks();
  /// for (var bank in banks) {
  ///   print('${bank.name}: ${bank.code}');
  /// }
  /// ```
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

  /// Get payment status
  ///
  /// [reference] - The payment reference
  ///
  /// Example:
  /// ```dart
  /// final payment = await lenco.payments.getPaymentStatus(
  ///   reference: 'PAY-REF-123',
  /// );
  /// print('Status: ${payment.status}');
  /// ```
  Future<PaymentResponse> getPaymentStatus({
    required String reference,
  }) async {
    final response = await _client.get(
      'payments/$reference',
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

  /// Initiate bulk transfer
  ///
  /// [accountId] - Source account ID
  /// [transfers] - List of payment requests
  ///
  /// Example:
  /// ```dart
  /// final result = await lenco.payments.initiateBulkTransfer(
  ///   accountId: 'account-id',
  ///   transfers: [
  ///     PaymentRequest(...),
  ///     PaymentRequest(...),
  ///   ],
  /// );
  /// ```
  Future<Map<String, dynamic>> initiateBulkTransfer({
    required String accountId,
    required List<PaymentRequest> transfers,
  }) async {
    final body = {
      'accountId': accountId,
      'transfers': transfers.map((t) => t.toJson()).toList(),
    };

    final response = await _client.post(
      'payments/bulk-transfer',
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

  /// Get transfer fee
  ///
  /// [amount] - Transfer amount
  /// [bankCode] - Destination bank code
  ///
  /// Returns the calculated transfer fee
  Future<String> getTransferFee({
    required String amount,
    required String bankCode,
  }) async {
    final queryParams = {
      'amount': amount,
      'bankCode': bankCode,
    };

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
