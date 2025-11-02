import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lenco_flutter/lenco_flutter.dart';
import 'package:lenco_flutter/src/services/v2/account_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/transaction_service.dart' as v2;
import 'package:lenco_flutter/src/services/v2/payment_service.dart' as v2;

import 'lenco_flutter_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('LencoConfig', () {
    test('should create production config correctly', () {
      final config = LencoConfig.production(apiKey: 'test-key');

      expect(config.apiKey, 'test-key');
      expect(config.baseUrl, 'https://api.lenco.co');
      expect(config.version, LencoApiVersion.v2);
      expect(config.debugMode, false);
    });

    test('should create sandbox config correctly', () {
      final config = LencoConfig.sandbox(apiKey: 'test-key');

      expect(config.apiKey, 'test-key');
      expect(config.baseUrl, 'https://sandbox-api.lenco.co');
      expect(config.debugMode, true);
    });

    test('should generate correct versioned base URL', () {
      final config = LencoConfig.production(apiKey: 'test-key');
      expect(config.versionedBaseUrl, 'https://api.lenco.co/access/v2');

      final configV2 = LencoConfig.production(
        apiKey: 'test-key',
        version: LencoApiVersion.v2,
      );
      expect(configV2.versionedBaseUrl, 'https://api.lenco.co/access/v2');
    });

    test('should copy with new values', () {
      final original = LencoConfig.production(apiKey: 'original');
      final updated = original.copyWith(apiKey: 'updated');

      expect(updated.apiKey, 'updated');
      expect(updated.baseUrl, original.baseUrl);
    });
  });

  group('LencoException', () {
    test('should create base exception', () {
      const exception = LencoException(message: 'Test error');

      expect(exception.message, 'Test error');
      expect(exception.toString(), 'LencoException: Test error');
    });

    test('should create authentication exception', () {
      const exception = LencoAuthenticationException();

      expect(exception.message, 'Authentication failed. Check your API key.');
      expect(exception.statusCode, 401);
    });

    test('should create validation exception with errors', () {
      const errors = {
        'field': ['error message'],
      };
      const exception = LencoValidationException(errors: errors);

      expect(exception.errors, errors);
      expect(exception.toString(), contains('Validation errors'));
    });

    test('should create network exception', () {
      const exception = LencoNetworkException();

      expect(exception.message, 'Network error. Check your connection.');
    });

    test('should create server exception', () {
      const exception = LencoServerException(statusCode: 500);

      expect(exception.statusCode, 500);
    });
  });

  group('Models', () {
    test('LencoAccount should serialize/deserialize correctly', () {
      final accountJson = {
        'id': 'acc-123',
        'name': 'Test Account',
        'bankAccount': {
          'accountName': 'John Doe',
          'accountNumber': '1234567890',
          'bank': {'code': '044', 'name': 'Access Bank'},
        },
        'type': 'business',
        'status': 'active',
        'availableBalance': '10000.00',
        'currentBalance': '10000.00',
        'createdAt': '2023-01-01T00:00:00Z',
        'currency': 'NGN',
      };

      final account = LencoAccount.fromJson(accountJson);
      final serialized = account.toJson();

      expect(account.id, 'acc-123');
      expect(account.name, 'Test Account');
      expect(account.bankAccount.accountNumber, '1234567890');
      expect(account.availableBalance, '10000.00');
      expect(serialized['id'], 'acc-123');
    });

    test('LencoTransaction should serialize/deserialize correctly', () {
      final transactionJson = {
        'id': 'txn-123',
        'reference': 'REF-123',
        'type': 'credit',
        'amount': '5000.00',
        'currency': 'NGN',
        'status': 'completed',
        'description': 'Payment received',
        'createdAt': '2023-01-01T00:00:00Z',
        'completedAt': '2023-01-01T00:01:00Z',
        'recipientName': 'Jane Doe',
        'recipientAccount': '0987654321',
      };

      final transaction = LencoTransaction.fromJson(transactionJson);
      final serialized = transaction.toJson();

      expect(transaction.id, 'txn-123');
      expect(transaction.reference, 'REF-123');
      expect(transaction.amount, '5000.00');
      expect(transaction.status, 'completed');
      expect(serialized['id'], 'txn-123');
    });

    test('PaymentRequest should serialize/deserialize correctly', () {
      const request = PaymentRequest(
        accountId: 'acc-123',
        amount: '10000',
        recipientAccountNumber: '1234567890',
        recipientBankCode: '044',
        narration: 'Test payment',
        reference: 'PAY-REF-123',
      );

      final serialized = request.toJson();
      final deserialized = PaymentRequest.fromJson(serialized);

      expect(deserialized.accountId, 'acc-123');
      expect(deserialized.amount, '10000');
      expect(deserialized.narration, 'Test payment');
    });

    test('PaymentResponse should serialize/deserialize correctly', () {
      final responseJson = {
        'id': 'pay-123',
        'reference': 'PAY-REF-123',
        'status': 'pending',
        'amount': '10000',
        'message': 'Payment initiated successfully',
      };

      final response = PaymentResponse.fromJson(responseJson);
      final serialized = response.toJson();

      expect(response.id, 'pay-123');
      expect(response.status, 'pending');
      expect(response.message, 'Payment initiated successfully');
      expect(serialized['id'], 'pay-123');
    });

    test('LencoApiResponse should handle generic types', () {
      final responseJson = {
        'status': true,
        'message': 'Success',
        'data': {'id': 'test-id', 'name': 'Test'},
        'errorCode': null,
        'errors': null,
      };

      final response = LencoApiResponse<Map<String, dynamic>>.fromJson(
        responseJson,
        (json) => json as Map<String, dynamic>,
      );

      expect(response.status, true);
      expect(response.message, 'Success');
      expect(response.data!['id'], 'test-id');
    });
  });

  group('LencoHttpClient', () {
    late MockClient mockClient;
    late LencoHttpClient httpClient;
    late LencoConfig config;

    setUp(() {
      mockClient = MockClient();
      config = LencoConfig.sandbox(apiKey: 'test-key');
      httpClient = LencoHttpClient(config: config, client: mockClient);
    });

    test('should make GET request successfully', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{
            'status': true,
            'message': 'Success',
            'data': <String, dynamic>{},
          }),
          200,
        ),
      );

      final result = await httpClient.get('test-endpoint');

      expect(result['status'], true);
      expect(result['message'], 'Success');
      verify(mockClient.get(any, headers: anyNamed('headers'))).called(1);
    });

    test('should make POST request successfully', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{
            'status': true,
            'message': 'Success',
            'data': <String, dynamic>{},
          }),
          201,
        ),
      );

      final result = await httpClient.post(
        'test-endpoint',
        body: {'test': 'data'},
      );

      expect(result['status'], true);
      verify(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).called(1);
    });

    test('should handle authentication error', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'status': false, 'message': 'Unauthorized'}),
          401,
        ),
      );

      expect(
        () => httpClient.get('test-endpoint'),
        throwsA(isA<LencoAuthenticationException>()),
      );
    });

    test('should handle validation error', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{
            'status': false,
            'message': 'Validation failed',
            'errors': <String, dynamic>{
              'field': ['error message'],
            },
          }),
          400,
        ),
      );

      expect(
        () => httpClient.post('test-endpoint', body: <String, dynamic>{}),
        throwsA(isA<LencoValidationException>()),
      );
    });

    test('should handle server error', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'status': false, 'message': 'Internal server error'}),
          500,
        ),
      );

      expect(
        () => httpClient.get('test-endpoint'),
        throwsA(isA<LencoServerException>()),
      );
    });

    test('should handle network timeout', () async {
      when(
        mockClient.get(any, headers: anyNamed('headers')),
      ).thenThrow(const SocketException('Network error'));

      expect(
        () => httpClient.get('test-endpoint'),
        throwsA(isA<LencoNetworkException>()),
      );
    });

    test('should include correct headers', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{
            'status': true,
            'message': 'Success',
            'data': <String, dynamic>{},
          }),
          200,
        ),
      );

      await httpClient.get('test-endpoint');

      final captured = verify(
        mockClient.get(any, headers: captureAnyNamed('headers')),
      ).captured;
      final headers = captured.first as Map<String, String>;

      expect(headers['Authorization'], 'Bearer test-key');
      expect(headers['Content-Type'], 'application/json');
      expect(headers['Accept'], 'application/json');
    });
  });

  group('AccountService', () {
    late MockClient mockClient;
    late LencoHttpClient httpClient;
    late AccountService accountService;

    setUp(() {
      mockClient = MockClient();
      final config = LencoConfig.sandbox(apiKey: 'test-key');
      httpClient = LencoHttpClient(config: config, client: mockClient);
      accountService = AccountService(httpClient);
    });

    test('should get accounts successfully', () async {
      final accountsJson = [
        {
          'id': 'acc-1',
          'name': 'Account 1',
          'bankAccount': {
            'accountName': 'John Doe',
            'accountNumber': '1234567890',
            'bank': {'code': '044', 'name': 'Access Bank'},
          },
          'type': 'business',
          'status': 'active',
          'availableBalance': '10000.00',
          'currentBalance': '10000.00',
          'createdAt': '2023-01-01T00:00:00Z',
          'currency': 'NGN',
        },
      ];

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': accountsJson,
          }),
          200,
        ),
      );

      final accounts = await accountService.getAccounts();

      expect(accounts.length, 1);
      expect(accounts.first.id, 'acc-1');
      expect(accounts.first.name, 'Account 1');
    });

    test('should get account by ID successfully', () async {
      final accountJson = {
        'id': 'acc-1',
        'name': 'Account 1',
        'bankAccount': {
          'accountName': 'John Doe',
          'accountNumber': '1234567890',
          'bank': {'code': '044', 'name': 'Access Bank'},
        },
        'type': 'business',
        'status': 'active',
        'availableBalance': '10000.00',
        'currentBalance': '10000.00',
        'createdAt': '2023-01-01T00:00:00Z',
        'currency': 'NGN',
      };

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': accountJson,
          }),
          200,
        ),
      );

      final account = await accountService.getAccountById('acc-1');

      expect(account.id, 'acc-1');
      expect(account.name, 'Account 1');
    });

    test('should get account balance successfully', () async {
      final balanceJson = {
        'available': '10000.00',
        'current': '10000.00',
        'currency': 'NGN',
      };

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': balanceJson,
          }),
          200,
        ),
      );

      final balance = await accountService.getAccountBalance('acc-1');

      expect(balance['available'], '10000.00');
      expect(balance['current'], '10000.00');
      expect(balance['currency'], 'NGN');
    });
  });

  group('TransactionService', () {
    late MockClient mockClient;
    late LencoHttpClient httpClient;
    late TransactionService transactionService;

    setUp(() {
      mockClient = MockClient();
      final config = LencoConfig.sandbox(apiKey: 'test-key');
      httpClient = LencoHttpClient(config: config, client: mockClient);
      transactionService = TransactionService(httpClient);
    });

    test('should get transactions successfully', () async {
      final transactionsJson = [
        {
          'id': 'txn-1',
          'reference': 'REF-1',
          'type': 'credit',
          'amount': '5000.00',
          'currency': 'NGN',
          'status': 'completed',
          'description': 'Payment received',
          'createdAt': '2023-01-01T00:00:00Z',
          'completedAt': '2023-01-01T00:01:00Z',
          'recipientName': 'Jane Doe',
          'recipientAccount': '0987654321',
        },
      ];

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': transactionsJson,
          }),
          200,
        ),
      );

      final transactions = await transactionService.getTransactions(
        accountId: 'acc-1',
        limit: 10,
        type: 'credit',
      );

      expect(transactions.length, 1);
      expect(transactions.first.id, 'txn-1');
      expect(transactions.first.type, 'credit');
    });

    test('should get transaction by ID successfully', () async {
      final transactionJson = {
        'id': 'txn-1',
        'reference': 'REF-1',
        'type': 'credit',
        'amount': '5000.00',
        'currency': 'NGN',
        'status': 'completed',
        'description': 'Payment received',
        'createdAt': '2023-01-01T00:00:00Z',
        'completedAt': '2023-01-01T00:01:00Z',
        'recipientName': 'Jane Doe',
        'recipientAccount': '0987654321',
      };

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': transactionJson,
          }),
          200,
        ),
      );

      final transaction = await transactionService.getTransactionById(
        accountId: 'acc-1',
        transactionId: 'txn-1',
      );

      expect(transaction.id, 'txn-1');
      expect(transaction.reference, 'REF-1');
    });

    test('should get transaction by reference successfully', () async {
      final transactionJson = {
        'id': 'txn-1',
        'reference': 'REF-1',
        'type': 'credit',
        'amount': '5000.00',
        'currency': 'NGN',
        'status': 'completed',
        'description': 'Payment received',
        'createdAt': '2023-01-01T00:00:00Z',
        'completedAt': '2023-01-01T00:01:00Z',
        'recipientName': 'Jane Doe',
        'recipientAccount': '0987654321',
      };

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': transactionJson,
          }),
          200,
        ),
      );

      final transaction = await transactionService.getTransactionByReference(
        reference: 'REF-1',
      );

      expect(transaction.reference, 'REF-1');
    });

    test('should download statement successfully', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {'downloadUrl': 'https://example.com/statement.pdf'},
          }),
          200,
        ),
      );

      final downloadUrl = await transactionService.downloadStatement(
        accountId: 'acc-1',
        startDate: '2023-01-01',
        endDate: '2023-01-31',
        format: 'pdf',
      );

      expect(downloadUrl, 'https://example.com/statement.pdf');
    });
  });

  group('PaymentService', () {
    late MockClient mockClient;
    late LencoHttpClient httpClient;
    late PaymentService paymentService;

    setUp(() {
      mockClient = MockClient();
      final config = LencoConfig.sandbox(apiKey: 'test-key');
      httpClient = LencoHttpClient(config: config, client: mockClient);
      paymentService = PaymentService(httpClient);
    });

    test('should initiate payment successfully', () async {
      const paymentRequest = PaymentRequest(
        accountId: 'acc-1',
        amount: '10000',
        recipientAccountNumber: '1234567890',
        recipientBankCode: '044',
        narration: 'Test payment',
      );

      final paymentResponseJson = {
        'id': 'pay-1',
        'reference': 'PAY-REF-1',
        'status': 'pending',
        'amount': '10000',
        'message': 'Payment initiated successfully',
      };

      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': paymentResponseJson,
          }),
          201,
        ),
      );

      final response = await paymentService.initiatePayment(paymentRequest);

      expect(response.id, 'pay-1');
      expect(response.reference, 'PAY-REF-1');
      expect(response.status, 'pending');
    });

    test('should verify account name successfully', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {'accountName': 'John Doe'},
          }),
          200,
        ),
      );

      final accountName = await paymentService.verifyAccountName(
        accountNumber: '1234567890',
        bankCode: '044',
      );

      expect(accountName, 'John Doe');
    });

    test('should get banks successfully', () async {
      final banksJson = [
        {'code': '044', 'name': 'Access Bank'},
        {'code': '058', 'name': 'GTBank'},
      ];

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'status': true, 'message': 'Success', 'data': banksJson}),
          200,
        ),
      );

      final banks = await paymentService.getBanks();

      expect(banks.length, 2);
      expect(banks.first.code, '044');
      expect(banks.first.name, 'Access Bank');
    });

    test('should get payment status successfully', () async {
      final paymentResponseJson = {
        'id': 'pay-1',
        'reference': 'PAY-REF-1',
        'status': 'completed',
        'amount': '10000',
        'message': 'Payment completed successfully',
      };

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': paymentResponseJson,
          }),
          200,
        ),
      );

      final response = await paymentService.getPaymentStatus(
        reference: 'PAY-REF-1',
      );

      expect(response.status, 'completed');
      expect(response.message, 'Payment completed successfully');
    });

    test('should initiate bulk transfer successfully', () async {
      const transfers = [
        PaymentRequest(
          accountId: 'acc-1',
          amount: '5000',
          recipientAccountNumber: '1234567890',
          recipientBankCode: '044',
          narration: 'Bulk payment 1',
        ),
        PaymentRequest(
          accountId: 'acc-1',
          amount: '3000',
          recipientAccountNumber: '0987654321',
          recipientBankCode: '058',
          narration: 'Bulk payment 2',
        ),
      ];

      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {'batchId': 'batch-123', 'totalAmount': '8000'},
          }),
          201,
        ),
      );

      final result = await paymentService.initiateBulkTransfer(
        accountId: 'acc-1',
        transfers: transfers,
      );

      expect(result['batchId'], 'batch-123');
      expect(result['totalAmount'], '8000');
    });

    test('should get transfer fee successfully', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {'fee': '50.00'},
          }),
          200,
        ),
      );

      final fee = await paymentService.getTransferFee(
        amount: '10000',
        bankCode: '044',
      );

      expect(fee, '50.00');
    });
  });

  group('LencoClient', () {
    late MockClient mockClient;
    late LencoClient client;

    setUp(() {
      mockClient = MockClient();
      final config = LencoConfig.sandbox(apiKey: 'test-key');
      client = LencoClient(config: config, httpClient: mockClient);
    });

    test('should create production client', () {
      final productionClient = LencoClient.production(apiKey: 'prod-key');

      expect(productionClient.config.apiKey, 'prod-key');
      expect(productionClient.config.baseUrl, 'https://api.lenco.co');
      expect(productionClient.config.debugMode, false);
    });

    test('should create sandbox client', () {
      final sandboxClient = LencoClient.sandbox(apiKey: 'sandbox-key');

      expect(sandboxClient.config.apiKey, 'sandbox-key');
      expect(sandboxClient.config.baseUrl, 'https://sandbox-api.lenco.co');
      expect(sandboxClient.config.debugMode, true);
    });

    test('should initialize services', () {
      // V2 is default, so services are v2
      expect(client.accounts, isA<v2.AccountServiceV2>());
      expect(client.transactions, isA<v2.TransactionServiceV2>());
      expect(client.payments, isA<v2.PaymentServiceV2>());
    });

    test('should close client', () {
      expect(() => client.close(), returnsNormally);
    });
  });

  group('Integration Tests', () {
    test('should handle complete payment flow', () async {
      final mockClient = MockClient();
      final config = LencoConfig.sandbox(apiKey: 'test-key');
      final client = LencoClient(config: config, httpClient: mockClient);

      // Mock account verification
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {'accountName': 'John Doe'},
          }),
          200,
        ),
      );

      // Mock payment initiation
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'Success',
            'data': {
              'id': 'pay-1',
              'reference': 'PAY-REF-1',
              'status': 'pending',
              'amount': '10000',
              'message': 'Payment initiated successfully',
            },
          }),
          201,
        ),
      );

      // Verify account (using v2 resolve service)
      final resolveResult = await client.resolve.bankAccount(
        accountNumber: '1234567890',
        bankCode: '044',
      );
      final accountName = resolveResult['accountName'] as String? ?? '';
      expect(accountName, 'John Doe');

      // Initiate payment (using v2 transfer method)
      final payment = await client.payments.transferToBankAccount(
        accountId: 'acc-1',
        amount: '10000',
        currency: 'NGN',
        reference: 'PAY-REF-1',
        recipientAccountNumber: '1234567890',
        recipientBankCode: '044',
        narration: 'Test payment',
      );
      expect(payment.reference, 'PAY-REF-1');
      expect(payment.status, 'pending');

      client.close();
    });
  });
}
