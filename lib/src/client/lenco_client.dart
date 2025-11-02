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
import 'package:lenco_flutter/src/client/http_client_v1.dart';
import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/services/v2/account_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/transaction_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/payment_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/collections_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/resolve_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/recipient_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/settlements_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/banks_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/virtual_account_service.dart'
    as v2;
import 'package:lenco_flutter/src/services/resolve_service.dart';

/// Main Lenco API client
///
/// V2 is the default API version. All primary service properties (accounts,
/// payments, collections, etc.) use v2 services when v2 is configured.
///
/// Example:
/// ```dart
/// // Default v2 usage
/// final lenco = LencoClient.production(apiKey: 'your-api-key');
///
/// // Get accounts (v2)
/// final accounts = await lenco.accounts.getAccounts();
///
/// // Accept payment (v2)
/// final collection = await lenco.collections.createCardCollection(
///   request: request,
///   cardNumber: '...',
///   expiryMonth: '12',
///   expiryYear: '25',
///   cvv: '123',
/// );
///
/// // Send payment (v2)
/// final payment = await lenco.payments.transferToBankAccount(
///   accountId: 'account-id',
///   amount: '10000',
///   currency: 'NGN',
///   reference: 'ref-123',
///   recipientAccountNumber: '1234567890',
///   recipientBankCode: '044',
/// );
/// ```
class LencoClient {
  final LencoConfig config;
  final Object _httpClient;

  // Primary service properties - use v2 by default
  late final v2.AccountServiceV2 accounts;
  late final v2.TransactionServiceV2 transactions;
  late final v2.PaymentServiceV2 payments;
  late final v2.CollectionsServiceV2 collections;
  late final v2.ResolveServiceV2 resolve;
  late final v2.RecipientServiceV2 recipients;
  late final v2.SettlementsServiceV2 settlements;
  late final v2.BanksServiceV2 banks;
  late final v2.VirtualAccountServiceV2 virtualAccounts;

  // V1 services - available for backward compatibility when v1 is configured
  late final AccountService? accountsV1;
  late final TransactionService? transactionsV1;
  late final PaymentService? paymentsV1;
  late final CollectionsService? collectionsV1;
  late final VirtualAccountService? virtualAccountsV1;
  late final RecipientService? recipientsV1;
  late final SettlementsService? settlementsV1;
  late final BanksService? banksV1;
  late final ResolveService? resolveV1;

  // Encryption service (version-agnostic)
  late final EncryptionService encryption;

  LencoClient({required this.config, http.Client? httpClient})
    : _httpClient = config.version == LencoApiVersion.v1
          ? HttpClientV1(config: config, client: httpClient)
          : HttpClientV2(config: config, client: httpClient) {
    // Initialize services based on version
    final legacyClient = LencoHttpClient(config: config, client: httpClient);

    if (_httpClient is HttpClientV2) {
      // V2 is default - primary properties use v2 services
      final v2Client = _httpClient;
      accounts = v2.AccountServiceV2(v2Client);
      transactions = v2.TransactionServiceV2(v2Client);
      payments = v2.PaymentServiceV2(v2Client);
      collections = v2.CollectionsServiceV2(v2Client);
      resolve = v2.ResolveServiceV2(v2Client);
      recipients = v2.RecipientServiceV2(v2Client);
      settlements = v2.SettlementsServiceV2(v2Client);
      banks = v2.BanksServiceV2(v2Client);
      virtualAccounts = v2.VirtualAccountServiceV2(v2Client);

      // V1 services not available in v2 mode
      accountsV1 = null;
      transactionsV1 = null;
      paymentsV1 = null;
      collectionsV1 = null;
      virtualAccountsV1 = null;
      recipientsV1 = null;
      settlementsV1 = null;
      banksV1 = null;
      resolveV1 = null;
    } else if (_httpClient is HttpClientV1) {
      // V1 mode - primary properties use v1 services
      accountsV1 = AccountService(legacyClient);
      transactionsV1 = TransactionService(legacyClient);
      paymentsV1 = PaymentService(legacyClient);
      collectionsV1 = CollectionsService(legacyClient);
      virtualAccountsV1 = VirtualAccountService(legacyClient);
      recipientsV1 = RecipientService(legacyClient);
      settlementsV1 = SettlementsService(legacyClient);
      banksV1 = BanksService(legacyClient);
      resolveV1 = ResolveService(legacyClient);

      // Create v2 client for primary properties (recommended to migrate to v2)
      final v2Client = HttpClientV2(
        config: config.copyWith(version: LencoApiVersion.v2),
        client: httpClient,
      );
      accounts = v2.AccountServiceV2(v2Client);
      transactions = v2.TransactionServiceV2(v2Client);
      payments = v2.PaymentServiceV2(v2Client);
      collections = v2.CollectionsServiceV2(v2Client);
      resolve = v2.ResolveServiceV2(v2Client);
      recipients = v2.RecipientServiceV2(v2Client);
      settlements = v2.SettlementsServiceV2(v2Client);
      banks = v2.BanksServiceV2(v2Client);
      virtualAccounts = v2.VirtualAccountServiceV2(v2Client);
    } else {
      // Fallback to legacy client - use v2 as default
      final c = _httpClient as LencoHttpClient;
      final v2Client = HttpClientV2(config: config, client: httpClient);

      accounts = v2.AccountServiceV2(v2Client);
      transactions = v2.TransactionServiceV2(v2Client);
      payments = v2.PaymentServiceV2(v2Client);
      collections = v2.CollectionsServiceV2(v2Client);
      resolve = v2.ResolveServiceV2(v2Client);
      recipients = v2.RecipientServiceV2(v2Client);
      settlements = v2.SettlementsServiceV2(v2Client);
      banks = v2.BanksServiceV2(v2Client);
      virtualAccounts = v2.VirtualAccountServiceV2(v2Client);

      accountsV1 = AccountService(c);
      transactionsV1 = TransactionService(c);
      paymentsV1 = PaymentService(c);
      collectionsV1 = CollectionsService(c);
      virtualAccountsV1 = VirtualAccountService(c);
      recipientsV1 = RecipientService(c);
      settlementsV1 = SettlementsService(c);
      banksV1 = BanksService(c);
      resolveV1 = ResolveService(c);
    }

    encryption = EncryptionService(legacyClient);
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
    if (_httpClient is LencoHttpClient) {
      _httpClient.close();
    } else if (_httpClient is HttpClientV1) {
      _httpClient.close();
    } else if (_httpClient is HttpClientV2) {
      _httpClient.close();
    }
  }
}
