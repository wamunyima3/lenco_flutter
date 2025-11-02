import 'package:lenco_flutter/src/models/api_response.dart';

abstract class PaymentsRepository {
  Future<PaymentResponse> transferToBankAccount({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String recipientAccountNumber,
    required String recipientBankCode,
    String? narration,
  });

  Future<PaymentResponse> transferToMobileMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String phone,
    required String operator,
    String country = 'ZM',
    String? narration,
  });

  Future<PaymentResponse> transferToLencoMoney({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String accountNumber,
    String? narration,
  });

  Future<PaymentResponse> transferToLencoMerchant({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String merchantId,
    String? narration,
  });

  Future<PaymentResponse> transferBetweenAccounts({
    required String accountId,
    required String amount,
    required String currency,
    required String reference,
    required String toAccountId,
    String? narration,
  });

  Future<List<PaymentResponse>> getTransfers({int page = 1, int limit = 50});

  Future<PaymentResponse> getTransferById(String id);

  Future<PaymentResponse> getTransferStatus(String reference);
}
