import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/payment_service.dart';

class PaymentsRemoteDataSourceV2 {
  final PaymentServiceV2 _service;

  PaymentsRemoteDataSourceV2(this._service);

  Future<PaymentResponse> transferToBankAccount({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String recipientAccountNumber,
    required String recipientBankCode,
    String? narration,
  }) {
    return _service.transferToBankAccount(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      recipientAccountNumber: recipientAccountNumber,
      recipientBankCode: recipientBankCode,
      narration: narration,
    );
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
  }) {
    return _service.transferToMobileMoney(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      phone: phone,
      operator: operator,
      country: country,
      narration: narration,
    );
  }

  Future<PaymentResponse> transferToLencoMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String accountNumber,
    String? narration,
  }) {
    return _service.transferToLencoMoney(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      accountNumber: accountNumber,
      narration: narration,
    );
  }

  Future<PaymentResponse> transferToLencoMerchant({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String merchantId,
    String? narration,
  }) {
    return _service.transferToLencoMerchant(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      merchantId: merchantId,
      narration: narration,
    );
  }

  Future<PaymentResponse> transferBetweenAccounts({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String toAccountId,
    String? narration,
  }) {
    return _service.transferBetweenAccounts(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      toAccountId: toAccountId,
      narration: narration,
    );
  }

  Future<List<PaymentResponse>> getTransfers({int page = 1, int limit = 50}) {
    return _service.getTransfers(page: page, limit: limit);
  }

  Future<PaymentResponse> getTransferById(String id) {
    return _service.getTransferById(id);
  }

  Future<PaymentResponse> getTransferStatus(String reference) {
    return _service.getTransferStatus(reference);
  }
}
