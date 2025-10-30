import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for payment-related operations
class PaymentService {
  final LencoHttpClient _client;

  PaymentService(this._client);

  // ========= v2 Transfers =========
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
    final response = await _client.post('transfers/bank-account', body: body);
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
    // Normalize per v2: MSISDN digits only, lowercase operator
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
    final response = await _client.post('transfers/mobile-money', body: body);
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
    final response = await _client.post('transfers/lenco-money', body: body);
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
    final response = await _client.post('transfers/lenco-merchant', body: body);
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
    final response = await _client.post('transfers/account', body: body);
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
      'transfers',
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
    final response = await _client.get('transfers/$id');
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
    final response = await _client.get('transfers/status/$reference');
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return PaymentResponse.fromJson(apiResponse.data!);
  }

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
  @Deprecated('Use transfers/bank-account (transferToBankAccount) in v2')
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
  @Deprecated('Use resolve/bank-account via ResolveService.bankAccount in v2')
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
  @Deprecated('Use transfers/status/:reference in v2 (getTransferStatus)')
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
  @Deprecated('Prefer v2 transfers endpoints; bulk payments/* is legacy')
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
  @Deprecated('Fee calculation via payments/fee is legacy; see v2 pricing')
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
