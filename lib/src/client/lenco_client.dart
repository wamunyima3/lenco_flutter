import 'package:http/http.dart' as http;
import 'package:lenco_flutter/src/config/lenco_config.dart';
import 'package:lenco_flutter/src/services/account_service.dart';
import 'package:lenco_flutter/src/services/transaction_service.dart';
import 'package:lenco_flutter/src/services/payment_service.dart';
import 'package:lenco_flutter/src/services/collections_service.dart';
import 'package:lenco_flutter/src/services/virtual_account_service.dart';
import 'package:lenco_flutter/src/services/recipient_service.dart';
import 'package:lenco_flutter/src/services/settlements_service.dart';
import 'package:lenco_flutter/src/services/banks_service.dart';
import 'package:lenco_flutter/src/services/encryption_service.dart';
import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/services/resolve_service.dart';

/// Main Lenco API client
///
/// Example:
/// ```dart
/// final lenco = LencoClient(
///   config: LencoConfig.production(apiKey: 'your-api-key'),
/// );
///
/// // Get accounts
/// final accounts = await lenco.accounts.getAccounts();
///
/// // Accept payment
/// final collection = await lenco.collections.createCardCollection(request);
///
/// // Send payment
/// final payment = await lenco.payments.initiatePayment(request);
/// ```
class LencoClient {
  final LencoConfig config;
  final LencoHttpClient _httpClient;

  late final AccountService accounts;
  late final TransactionService transactions;
  late final PaymentService payments;
  late final CollectionsService collections;
  late final VirtualAccountService virtualAccounts;
  late final RecipientService recipients;
  late final SettlementsService settlements;
  late final BanksService banks;
  late final ResolveService resolve;
  late final EncryptionService encryption;

  LencoClient({required this.config, http.Client? httpClient})
    : _httpClient = LencoHttpClient(config: config, client: httpClient) {
    // Initialize services
    accounts = AccountService(_httpClient);
    transactions = TransactionService(_httpClient);
    payments = PaymentService(_httpClient);
    collections = CollectionsService(_httpClient);
    virtualAccounts = VirtualAccountService(_httpClient);
    recipients = RecipientService(_httpClient);
    settlements = SettlementsService(_httpClient);
    banks = BanksService(_httpClient);
    resolve = ResolveService(_httpClient);
    encryption = EncryptionService(_httpClient);
  }

  factory LencoClient.production({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v2,
  }) {
    return LencoClient(
      config: LencoConfig.production(apiKey: apiKey, version: version),
    );
  }

  factory LencoClient.sandbox({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v2,
  }) {
    return LencoClient(
      config: LencoConfig.sandbox(apiKey: apiKey, version: version),
    );
  }

  /// Close the client and release resources
  void close() {
    _httpClient.close();
  }
}
