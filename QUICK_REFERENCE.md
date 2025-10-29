# Lenco Flutter - Quick Reference Card

## Installation

```yaml
dependencies:
  lenco_flutter: ^1.0.0
```

```bash
flutter pub get
```

## Initialization

```dart
import 'package:lenco_flutter/lenco_flutter.dart';

// Production
final lenco = LencoClient.production(apiKey: 'your-api-key');

// Sandbox (Testing)
final lenco = LencoClient.sandbox(apiKey: 'test-api-key');
```

## Common Operations

### Get Accounts

```dart
final accounts = await lenco.accounts.getAccounts();
```

### Get Account Balance

```dart
final balance = await lenco.accounts.getAccountBalance('account-id');
print('Available: ${balance['available']}');
```

### Get Transactions

```dart
final transactions = await lenco.transactions.getTransactions(
  accountId: 'account-id',
  limit: 50,
  type: 'credit', // or 'debit'
);
```

### Verify Account

```dart
final name = await lenco.payments.verifyAccountName(
  accountNumber: '1234567890',
  bankCode: '044',
);
```

### Get Banks

```dart
final banks = await lenco.payments.getBanks();
```

### Initiate Payment

```dart
final payment = await lenco.payments.initiatePayment(
  PaymentRequest(
    accountId: 'account-id',
    amount: '10000',
    recipientAccountNumber: '1234567890',
    recipientBankCode: '044',
    narration: 'Payment description',
  ),
);
```

### Check Payment Status

```dart
final payment = await lenco.payments.getPaymentStatus(
  reference: 'payment-reference',
);
```

### Bulk Transfer

```dart
final result = await lenco.payments.initiateBulkTransfer(
  accountId: 'account-id',
  transfers: [
    PaymentRequest(...),
    PaymentRequest(...),
  ],
);
```

## Error Handling

```dart
try {
  await lenco.payments.initiatePayment(request);
} on LencoAuthenticationException catch (e) {
  print('Auth error: ${e.message}');
} on LencoValidationException catch (e) {
  print('Validation error: ${e.message}');
  print('Errors: ${e.errors}');
} on LencoNotFoundException catch (e) {
  print('Not found: ${e.message}');
} on LencoNetworkException catch (e) {
  print('Network error: ${e.message}');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

## Exception Types

- `LencoAuthenticationException` - 401: Invalid API key
- `LencoValidationException` - 400: Invalid request data
- `LencoNotFoundException` - 404: Resource not found
- `LencoRateLimitException` - 429: Too many requests
- `LencoServerException` - 500+: Server error
- `LencoNetworkException` - Network/timeout error
- `LencoException` - Base exception

## Configuration Options

```dart
final lenco = LencoClient(
  config: LencoConfig(
    apiKey: 'your-key',
    baseUrl: 'https://api.lenco.co',
    version: LencoApiVersion.v1, // or v2
    timeout: Duration(seconds: 30),
    debugMode: true,
  ),
);
```

## Best Practices

1. ✅ Always verify account before payment
2. ✅ Use unique references for transactions
3. ✅ Handle errors specifically
4. ✅ Close client when done: `lenco.close()`
5. ✅ Use sandbox for testing

## Common Bank Codes

- Access Bank: `044`
- GTBank: `058`
- Zenith Bank: `057`
- First Bank: `011`
- UBA: `033`
- Stanbic IBTC: `221`

*Get full list with `lenco.payments.getBanks()`*

## Testing

```dart
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

final mockClient = MockClient();
final lenco = LencoClient(
  config: LencoConfig(apiKey: 'test'),
  httpClient: mockClient,
);
```

## Development Commands

```bash
# Get dependencies
flutter pub get

# Format code
dart format .

# Analyze code
dart analyze

# Run tests
flutter test

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Publish (dry run)
flutter pub publish --dry-run

# Publish
flutter pub publish
```

## Links

- **Package**: https://pub.dev/packages/lenco_flutter
- **API Docs**: https://lenco-api.readme.io
- **GitHub**: https://github.com/wamunyima3/lenco_flutter
- **Issues**: https://github.com/wamunyima3/lenco_flutter/issues

## Support

📧 Email: wamunyimamukelabai3@gmail.com  
🐛 Issues: GitHub Issues  
📖 Docs: README.md

---

**Version**: 1.0.0  
**License**: MIT