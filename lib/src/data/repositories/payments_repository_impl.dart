import 'package:lenco_flutter/src/data/datasources/v2/payments_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/payments_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSourceV2 _remoteV2;

  PaymentsRepositoryImpl(this._remoteV2);

  @override
  Future<PaymentResponse> transferToBankAccount({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String recipientAccountNumber,
    required String recipientBankCode,
    String? narration,
  }) {
    return _remoteV2.transferToBankAccount(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      recipientAccountNumber: recipientAccountNumber,
      recipientBankCode: recipientBankCode,
      narration: narration,
    );
  }

  @override
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
    return _remoteV2.transferToMobileMoney(
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

  @override
  Future<PaymentResponse> transferToLencoMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String accountNumber,
    String? narration,
  }) {
    return _remoteV2.transferToLencoMoney(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      accountNumber: accountNumber,
      narration: narration,
    );
  }

  @override
  Future<PaymentResponse> transferToLencoMerchant({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String merchantId,
    String? narration,
  }) {
    return _remoteV2.transferToLencoMerchant(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      merchantId: merchantId,
      narration: narration,
    );
  }

  @override
  Future<PaymentResponse> transferBetweenAccounts({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String toAccountId,
    String? narration,
  }) {
    return _remoteV2.transferBetweenAccounts(
      accountId: accountId,
      amount: amount,
      currency: currency,
      reference: reference,
      toAccountId: toAccountId,
      narration: narration,
    );
  }

  @override
  Future<List<PaymentResponse>> getTransfers({int page = 1, int limit = 50}) {
    return _remoteV2.getTransfers(page: page, limit: limit);
  }

  @override
  Future<PaymentResponse> getTransferById(String id) {
    return _remoteV2.getTransferById(id);
  }

  @override
  Future<PaymentResponse> getTransferStatus(String reference) {
    return _remoteV2.getTransferStatus(reference);
  }
}
