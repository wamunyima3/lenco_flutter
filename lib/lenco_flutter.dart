/// A production-ready Flutter package for integrating Lenco payment gateway.
///
/// This package provides easy-to-use APIs for:
/// - Account management
/// - Transaction history
/// - Bank transfers and payments
/// - Mobile money operations
/// - Account verification
///
/// ## Getting Started
///
/// First, create a Lenco client:
///
/// ```dart
/// import 'package:lenco_flutter/lenco_flutter.dart';
///
/// final lenco = LencoClient.production(
///   apiKey: 'your-api-key',
/// );
/// ```
///
/// ## Usage Examples
///
/// ### Get Accounts
/// ```dart
/// try {
///   final accounts = await lenco.accounts.getAccounts();
///   for (var account in accounts) {
///     print('${account.name}: ${account.availableBalance}');
///   }
/// } on LencoException catch (e) {
///   print('Error: ${e.message}');
/// }
/// ```
///
/// ### Make a Payment
/// ```dart
/// try {
///   // Verify account first
///   final accountName = await lenco.payments.verifyAccountName(
///     accountNumber: '1234567890',
///     bankCode: '044',
///   );
///
///   // Initiate payment
///   final payment = await lenco.payments.initiatePayment(
///     PaymentRequest(
///       accountId: 'your-account-id',
///       amount: '10000',
///       recipientAccountNumber: '1234567890',
///       recipientBankCode: '044',
///       narration: 'Payment for services',
///     ),
///   );
///
///   print('Payment initiated: ${payment.reference}');
/// } on LencoException catch (e) {
///   print('Error: ${e.message}');
/// }
/// ```
///
/// ### Get Transactions
/// ```dart
/// final transactions = await lenco.transactions.getTransactions(
///   accountId: 'account-id',
///   limit: 50,
///   type: 'credit',
/// );
/// ```
library lenco_flutter;

// Core client
export 'src/client/lenco_client.dart';
export 'src/client/http_client.dart';

// Configuration
export 'src/config/lenco_config.dart';

// Models
export 'src/models/api_response.dart';

// Exceptions
export 'src/exceptions/lenco_exception.dart';

// Services
export 'src/services/account_service.dart';
export 'src/services/transaction_service.dart';
export 'src/services/payment_service.dart';
