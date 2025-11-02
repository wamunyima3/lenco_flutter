import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:lenco_flutter/lenco_flutter.dart';
import 'lenco_flutter_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('V2 contract - HTTP payloads and endpoints', () {
    late MockClient mockClient;
    late LencoClient lenco;

    setUp(() {
      mockClient = MockClient();
      final config = LencoConfig.sandbox(
        apiKey: 'key',
        version: LencoApiVersion.v2,
      );
      lenco = LencoClient(config: config, httpClient: mockClient);
    });

    test(
      'Collections mobile-money v2 uses phone/operator/country with MSISDN',
      () async {
        // Arrange: capture request
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
              'message': 'ok',
              'data': {
                'id': 'col-1',
                'reference': 'REF',
                'status': 'pending',
                'amount': '100',
                'currency': 'USD',
                'createdAt': DateTime.now().toIso8601String(),
              },
            }),
            200,
          ),
        );

        const req = CollectionRequest(
          amount: '100',
          currency: 'USD',
          reference: 'REF',
        );
        await lenco.collections.createMobileMoneyCollection(
          request: req,
          phone: '0971234567',
          operator: 'MTN',
          country: 'ZM',
        );

        final captured = verify(
          mockClient.post(
            captureAny,
            headers: anyNamed('headers'),
            body: captureAnyNamed('body'),
          ),
        ).captured;
        final uri = captured[0] as Uri;
        final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;

        expect(uri.path, contains('/access/v2/collections/mobile-money'));
        expect(body['phone'], '260971234567');
        expect(body['operator'], 'MTN'.toLowerCase());
        expect(body['country'], 'ZM');
      },
    );

    test('Collections OTP v2 sends id and otp in body', () async {
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
            'message': 'ok',
            'data': {
              'id': 'col-1',
              'reference': 'REF',
              'status': 'pending',
              'amount': '100',
              'currency': 'USD',
              'createdAt': DateTime.now().toIso8601String(),
            },
          }),
          200,
        ),
      );

      await lenco.collections.submitMobileMoneyOtp(
        collectionId: 'col-1',
        otp: '123456',
      );

      final captured = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;
      final uri = captured[0] as Uri;
      final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;

      expect(
        uri.path,
        contains('/access/v2/collections/mobile-money/submit-otp'),
      );
      expect(body['id'], 'col-1');
      expect(body['otp'], '123456');
    });

    test('Transfers mobile-money v2 normalizes MSISDN and operator', () async {
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
            'message': 'ok',
            'data': {
              'id': 'tr-1',
              'reference': 'REF',
              'status': 'pending',
              'amount': '100',
            },
          }),
          200,
        ),
      );

      await lenco.payments.transferToMobileMoney(
        accountId: 'acc-1',
        amount: '100',
        currency: 'USD',
        reference: 'REF',
        phone: '+260971234567',
        operator: 'MTN',
      );

      final captured = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;
      final uri = captured[0] as Uri;
      final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;

      expect(uri.path, contains('/access/v2/transfers/mobile-money'));
      expect(body['phone'], '260971234567');
      expect(body['operator'], 'mtn');
    });

    test('Resolve mobile-money v2 normalizes MSISDN and operator', () async {
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
            'message': 'ok',
            'data': {'name': 'John Doe'},
          }),
          200,
        ),
      );

      await lenco.resolve.mobileMoney(phone: '0971234567', operator: 'Airtel');

      final captured = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;
      final uri = captured[0] as Uri;
      final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;

      expect(uri.path, contains('/access/v2/resolve/mobile-money'));
      expect(body['phone'], '260971234567');
      expect(body['operator'], 'airtel');
    });

    test('Transactions v2 list and get by id', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((
        invocation,
      ) async {
        final uri = invocation.positionalArguments[0] as Uri;
        if (uri.path.contains('/transactions/tx-1')) {
          return http.Response(
            jsonEncode({
              'status': true,
              'message': 'ok',
              'data': {
                'id': 'tx-1',
                'reference': 'R',
                'type': 'debit',
                'amount': '10',
                'currency': 'USD',
                'status': 'completed',
                'description': 'desc',
                'createdAt': DateTime.now().toIso8601String(),
              },
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'status': true,
            'message': 'ok',
            'data': [
              {
                'id': 'tx-1',
                'reference': 'R',
                'type': 'debit',
                'amount': '10',
                'currency': 'USD',
                'status': 'completed',
                'description': 'desc',
                'createdAt': DateTime.now().toIso8601String(),
              },
            ],
          }),
          200,
        );
      });

      final list = await lenco.transactions.getTransactions(limit: 1);
      expect(list, isNotEmpty);

      final one = await lenco.transactions.getTransactionById('tx-1');
      expect(one.id, 'tx-1');
    });

    test('Accounts v2 balance endpoint', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'ok',
            'data': {'available': '1', 'current': '1', 'currency': 'USD'},
          }),
          200,
        ),
      );

      final balance = await lenco.accounts.getAccountBalance('acc-1');
      expect(balance['currency'], 'USD');
    });

    test('Banks v2 list endpoint', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'ok',
            'data': [
              {'code': '001', 'name': 'Bank A'},
            ],
          }),
          200,
        ),
      );

      final banks = await lenco.banks.getBanks();
      expect(banks, isNotEmpty);

      final captured = verify(
        mockClient.get(captureAny, headers: anyNamed('headers')),
      ).captured;
      final uri = captured.first as Uri;
      expect(uri.path, contains('/access/v2/banks'));
    });

    test('Resolve bank-account v2 posts accountNumber and bankCode', () async {
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
            'message': 'ok',
            'data': {'name': 'John Doe'},
          }),
          200,
        ),
      );

      await lenco.resolve.bankAccount(
        accountNumber: '1234567890',
        bankCode: '044',
      );

      final captured = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;
      final uri = captured[0] as Uri;
      final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;
      expect(uri.path, contains('/access/v2/resolve/bank-account'));
      expect(body['accountNumber'], '1234567890');
      expect(body['bankCode'], '044');
    });

    test('Transfers bank-account v2 posts required fields', () async {
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
            'message': 'ok',
            'data': {
              'id': 'tr-2',
              'reference': 'REF2',
              'status': 'pending',
              'amount': '50',
            },
          }),
          200,
        ),
      );

      await lenco.payments.transferToBankAccount(
        accountId: 'acc-1',
        amount: '50',
        currency: 'USD',
        reference: 'REF2',
        recipientAccountNumber: '1234567890',
        recipientBankCode: '044',
      );

      final captured = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;
      final uri = captured[0] as Uri;
      final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;
      expect(uri.path, contains('/access/v2/transfers/bank-account'));
      expect(body['accountId'], 'acc-1');
      expect(body['amount'], '50');
      expect(body['currency'], 'USD');
      expect(body['reference'], 'REF2');
      expect(body['recipientAccountNumber'], '1234567890');
      expect(body['recipientBankCode'], '044');
    });

    test('Transfers status by reference v2 uses correct path', () async {
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': true,
            'message': 'ok',
            'data': {
              'id': 'tr-2',
              'reference': 'REF2',
              'status': 'success',
              'amount': '50',
            },
          }),
          200,
        ),
      );

      await lenco.payments.getTransferStatus('REF2');

      final captured = verify(
        mockClient.get(captureAny, headers: anyNamed('headers')),
      ).captured;
      final uri = captured.first as Uri;
      expect(uri.path, contains('/access/v2/transfers/status/REF2'));
    });

    test('Recipients v2 creation endpoints payloads', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((invocation) async {
        final now = DateTime.now().toIso8601String();
        final body = invocation.namedArguments[#body] as String?;
        final parsed = body != null
            ? jsonDecode(body) as Map<String, dynamic>
            : <String, dynamic>{};
        // Minimal valid Recipient payload for SDK parsing
        final recipientPayload = {
          'id': 'rcp-1',
          'name': parsed['accountName'] ?? parsed['name'] ?? 'John Doe',
          'accountNumber':
              parsed['accountNumber'] ?? parsed['phone'] ?? '1234567890',
          'bank': {'code': parsed['bankCode'] ?? '044', 'name': 'Access Bank'},
          'type': parsed.containsKey('merchantId')
              ? 'lenco-merchant'
              : (parsed.containsKey('operator')
                    ? 'mobile-money'
                    : (parsed.containsKey('accountNumber')
                          ? 'bank-account'
                          : 'lenco-money')),
          'createdAt': now,
        };
        return http.Response(
          jsonEncode({
            'status': true,
            'message': 'ok',
            'data': recipientPayload,
          }),
          200,
        );
      });

      await lenco.recipients.createBankAccountRecipient(
        accountName: 'John Doe',
        accountNumber: '1234567890',
        bankCode: '044',
      );
      await lenco.recipients.createMobileMoneyRecipient(
        name: 'Jane',
        phone: '0971234567',
        operator: 'mtn',
      );
      await lenco.recipients.createLencoMoneyRecipient(
        name: 'Bob',
        accountNumber: 'LM123',
      );
      await lenco.recipients.createLencoMerchantRecipient(
        name: 'Shop',
        merchantId: 'M123',
      );

      final allPosts = verify(
        mockClient.post(
          captureAny,
          headers: anyNamed('headers'),
          body: captureAnyNamed('body'),
        ),
      ).captured;

      // bank-account
      final bankUri = allPosts[0] as Uri;
      final bankBody =
          jsonDecode(allPosts[1] as String) as Map<String, dynamic>;
      expect(
        bankUri.path,
        contains('/access/v2/transfer-recipients/bank-account'),
      );
      expect(bankBody['accountName'], 'John Doe');

      // mobile-money
      final mmUri = allPosts[2] as Uri;
      final mmBody = jsonDecode(allPosts[3] as String) as Map<String, dynamic>;
      expect(
        mmUri.path,
        contains('/access/v2/transfer-recipients/mobile-money'),
      );
      expect(mmBody['phone'], '0971234567');

      // lenco-money
      final lmUri = allPosts[4] as Uri;
      final lmBody = jsonDecode(allPosts[5] as String) as Map<String, dynamic>;
      expect(
        lmUri.path,
        contains('/access/v2/transfer-recipients/lenco-money'),
      );
      expect(lmBody['accountNumber'], 'LM123');

      // lenco-merchant
      final merchUri = allPosts[6] as Uri;
      final merchBody =
          jsonDecode(allPosts[7] as String) as Map<String, dynamic>;
      expect(
        merchUri.path,
        contains('/access/v2/transfer-recipients/lenco-merchant'),
      );
      expect(merchBody['merchantId'], 'M123');
    });

    test('Error mapping: transfers 400 -> LencoValidationException', () async {
      when(
        mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'status': false,
            'message': 'Validation failed',
            'errors': {
              'amount': ['required'],
            },
          }),
          400,
        ),
      );

      expect(
        () => lenco.payments.transferToBankAccount(
          accountId: 'acc-1',
          amount: '',
          currency: 'USD',
          reference: 'REF',
          recipientAccountNumber: '123',
          recipientBankCode: '044',
        ),
        throwsA(isA<LencoValidationException>()),
      );
    });

    test(
      'MSISDN normalization and operator mismatch warning (logger)',
      () async {
        final logs = <String>[];
        final cfg = LencoConfig.sandbox(
          apiKey: 'key',
          version: LencoApiVersion.v2,
          debugMode: true,
          logger: logs.add,
        );
        final c = LencoClient(config: cfg, httpClient: mockClient);

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
              'message': 'ok',
              'data': {
                'id': 'col-1',
                'reference': 'R',
                'status': 'pending',
                'amount': '1',
                'currency': 'USD',
                'createdAt': DateTime.now().toIso8601String(),
              },
            }),
            200,
          ),
        );

        await c.collections.createMobileMoneyCollection(
          request: const CollectionRequest(
            amount: '1',
            currency: 'USD',
            reference: 'R',
          ),
          phone: '+260 971 234 567',
          operator: 'mtn', // phone 097.. suggests airtel; pass mtn to mismatch
        );

        final captured = verify(
          mockClient.post(
            captureAny,
            headers: anyNamed('headers'),
            body: captureAnyNamed('body'),
          ),
        ).captured;
        final body = jsonDecode(captured[1] as String) as Map<String, dynamic>;
        expect(body['phone'], '260971234567');
        expect(logs.any((m) => m.contains('Warning: MSISDN suggests')), isTrue);
      },
    );
  });
}
