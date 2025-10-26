import 'package:http/http.dart' as http;
import 'package:lenco_flutter/src/config/lenco_config.dart';
import 'package:lenco_flutter/src/services/account_service.dart';
import 'package:lenco_flutter/src/services/transaction_service.dart';
import 'package:lenco_flutter/src/services/payment_service.dart';
import 'package:lenco_flutter/src/client/http_client.dart';

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
/// // Make payment
/// final payment = await lenco.payments.initiatePayment(request);
/// ```
class LencoClient {
  final LencoConfig config;
  final LencoHttpClient _httpClient;

  late final AccountService accounts;
  late final TransactionService transactions;
  late final PaymentService payments;

  LencoClient({
    required this.config,
    http.Client? httpClient,
  }) : _httpClient = LencoHttpClient(
          config: config,
          client: httpClient,
        ) {
    // Initialize services
    accounts = AccountService(_httpClient);
    transactions = TransactionService(_httpClient);
    payments = PaymentService(_httpClient);
  }

  factory LencoClient.production({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
  }) {
    return LencoClient(
      config: LencoConfig.production(
        apiKey: apiKey,
        version: version,
      ),
    );
  }

  factory LencoClient.sandbox({
    required String apiKey,
    LencoApiVersion version = LencoApiVersion.v1,
  }) {
    return LencoClient(
      config: LencoConfig.sandbox(
        apiKey: apiKey,
        version: version,
      ),
    );
  }

  /// Close the client and release resources
  void close() {
    _httpClient.close();
  }
}
