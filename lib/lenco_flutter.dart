/// A production-ready Flutter package for integrating Lenco payment gateway.
///
/// This package provides easy-to-use APIs for:
/// - Account management
/// - Transaction history
/// - Accept payments (collections, cards, mobile money)
/// - Send payments (transfers)
/// - Virtual accounts for receiving funds
/// - Recipient management
/// - Settlement tracking
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
///
/// ### Accept Payment (Collection)
/// ```dart
/// try {
///   final collection = await lenco.collections.createCardCollection(
///     CollectionRequest(
///       amount: '10000',
///       currency: 'NGN',
///       reference: 'ORDER-123',
///     ),
///     cardNumber: '4532015112830366',
///     expiryMonth: '12',
///     expiryYear: '25',
///     cvv: '123',
///   );
///   print('Collection created: ${collection.reference}');
/// } on LencoException catch (e) {
///   print('Error: ${e.message}');
/// }
/// ```
///
/// ### Create Virtual Account
/// ```dart
/// try {
///   final virtualAccount = await lenco.virtualAccounts.createVirtualAccount(
///     accountName: 'John Doe',
///   );
///   print('Virtual Account: ${virtualAccount.accountNumber}');
/// } on LencoException catch (e) {
///   print('Error: ${e.message}');
/// }
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
export 'src/services/collections_service.dart';
export 'src/services/virtual_account_service.dart';
export 'src/services/recipient_service.dart';
export 'src/services/settlements_service.dart';
