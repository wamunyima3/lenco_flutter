import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:lenco_flutter/lenco_flutter.dart';
import 'package:lenco_flutter/src/client/http_client_v2.dart';

import 'lenco_flutter_test.mocks.dart';

void main() {
  group('BaseHttpClient retries and interceptors', () {
    late MockClient mockClient;
    late HttpClientV2 client;
    late List<String> logs;

    setUp(() {
      mockClient = MockClient();
      logs = <String>[];
      final cfg = LencoConfig.sandbox(
        apiKey: 'key',
        version: LencoApiVersion.v2,
        debugMode: true,
        logger: logs.add,
        maxRetries: 2,
      );
      client = HttpClientV2(config: cfg, client: mockClient);
    });

    test('retries on 500 and eventually succeeds', () async {
      var call = 0;
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) {
        call += 1;
        if (call < 2) {
          return Future.value(
            http.Response(jsonEncode({'status': false, 'message': 'err'}), 500),
          );
        }
        return Future.value(
          http.Response(
            jsonEncode(<String, dynamic>{
              'status': true,
              'message': 'ok',
              'data': <String, dynamic>{},
            }),
            200,
          ),
        );
      });

      final res = await client.get('health');
      expect(res['status'], true);
      verify(
        mockClient.get(any, headers: anyNamed('headers')),
      ).called(greaterThanOrEqualTo(2));
    });

    test('onRequest and onResponse interceptors fire', () async {
      final cfg = LencoConfig.sandbox(
        apiKey: 'key',
        onRequest:
            ({
              required String method,
              required String endpoint,
              Map<String, dynamic>? body,
              Map<String, dynamic>? queryParameters,
            }) async {
              logs.add('onRequest:$method:$endpoint');
              return;
            },
        onResponse:
            ({
              required String method,
              required String endpoint,
              required int statusCode,
              required Map<String, dynamic> json,
            }) async {
              logs.add('onResponse:$statusCode');
              return;
            },
      );
      final c = HttpClientV2(config: cfg, client: mockClient);

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          jsonEncode(<String, dynamic>{
            'status': true,
            'message': 'ok',
            'data': <String, dynamic>{},
          }),
          200,
        ),
      );

      await c.get('ping');
      expect(logs.any((l) => l.startsWith('onRequest:GET:ping')), isTrue);
      expect(logs.any((l) => l.startsWith('onResponse:200')), isTrue);
    });
  });
}
