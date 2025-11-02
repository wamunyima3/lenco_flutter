/// Centralized API endpoint paths for Lenco API v2
class Endpoints {
  Endpoints._();

  // Accounts
  static const String accounts = 'accounts';
  static String accountById(String id) => 'accounts/$id';
  static String accountBalance(String id) => 'accounts/$id/balance';

  // Transactions
  static const String transactions = 'transactions';
  static String transactionById(String id) => 'transactions/$id';

  // Transfers (v2 uses transfers instead of payments)
  static const String transfers = 'transfers';
  static String transferById(String id) => 'transfers/$id';
  static String transferStatus(String reference) =>
      'transfers/status/$reference';
  static const String transferBankAccount = 'transfers/bank-account';
  static const String transferMobileMoney = 'transfers/mobile-money';
  static const String transferLencoMoney = 'transfers/lenco-money';
  static const String transferLencoMerchant = 'transfers/lenco-merchant';
  static const String transferAccount = 'transfers/account';

  // Collections
  static const String collections = 'collections';
  static String collectionById(String id) => 'collections/$id';
  static String collectionStatus(String reference) =>
      'collections/status/$reference';
  static const String collectionMobileMoney = 'collections/mobile-money';
  static const String collectionMobileMoneySubmitOtp =
      'collections/mobile-money/submit-otp';
  static const String collectionCard = 'collections/card';

  // Recipients (v2 uses transfer-recipients)
  static const String transferRecipients = 'transfer-recipients';
  static String transferRecipientById(String recipientId) =>
      'transfer-recipients/$recipientId';
  static const String transferRecipientBankAccount =
      'transfer-recipients/bank-account';
  static const String transferRecipientMobileMoney =
      'transfer-recipients/mobile-money';
  static const String transferRecipientLencoMoney =
      'transfer-recipients/lenco-money';
  static const String transferRecipientLencoMerchant =
      'transfer-recipients/lenco-merchant';

  // Banks
  static const String banks = 'banks';
  static const String bankResolve = 'resolve';
  static const String resolveBankAccount = 'resolve/bank-account';
  static const String resolveMobileMoney = 'resolve/mobile-money';
  static const String resolveLencoMoney = 'resolve/lenco-money';
  static const String resolveLencoMerchant = 'resolve/lenco-merchant';

  // Settlements
  static const String settlements = 'settlements';
  static String settlementById(String settlementId) =>
      'settlements/$settlementId';

  // Virtual Accounts
  static const String virtualAccounts = 'virtual-accounts';
  static String virtualAccountByReference(String accountReference) =>
      'virtual-accounts/$accountReference';
  static const String virtualAccountTransactions =
      'virtual-accounts/transactions';
}
