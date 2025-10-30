# Lenco Flutter

[![pub package](https://img.shields.io/pub/v/lenco_flutter.svg)](https://pub.dev/packages/lenco_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Flutter package for integrating Lenco payment gateway. This package provides a comprehensive, type-safe, and easy-to-use interface for Lenco's API.

**Created by [Wamunyima Mukelabai](https://wamunyimamukelabai.vercel.app/)**

## Features

✅ **Account Management** - Get accounts, balances, and account details  
✅ **Accept Payments** - Collections (card, mobile money) - NEW!  
✅ **Virtual Accounts** - Receive payments via dedicated accounts - NEW!  
✅ **Recipient Management** - Save and manage payment recipients - NEW!  
✅ **Settlements** - Track payouts and settlements - NEW!  
✅ **Transaction History** - Fetch and filter transactions with pagination  
✅ **Bank Transfers** - Initiate single and bulk transfers  
✅ **Account Verification** - Verify account names before transfers  
✅ **Bank List** - Get all supported Nigerian banks  
✅ **Type-Safe Models** - Full type safety with generated JSON serialization  
✅ **Error Handling** - Comprehensive exception hierarchy  
✅ **API v1 & v2 Support** - Works with both API versions  
✅ **Testing Support** - Sandbox environment for development

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  lenco_flutter: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Initialize the Client

```dart
import 'package:lenco_flutter/lenco_flutter.dart';

// Production environment
final lenco = LencoClient.production(
  apiKey: 'your-api-key',
);

// Sandbox environment (for testing)
final lenco = LencoClient.sandbox(
  apiKey: 'your-test-api-key',
);

// Custom configuration
final lenco = LencoClient(
  config: LencoConfig(
    apiKey: 'your-api-key',
    baseUrl: 'https://api.lenco.co',
    version: LencoApiVersion.v1,
    timeout: Duration(seconds: 30),
    debugMode: true,
  ),
);
```

### Get All Accounts

```dart
try {
  final accounts = await lenco.accounts.getAccounts();

  for (var account in accounts) {
    print('Account: ${account.name}');
    print('Balance: ${account.availableBalance} ${account.currency}');
    print('Account Number: ${account.bankAccount.accountNumber}');
    print('Bank: ${account.bankAccount.bank.name}');
    print('---');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Get Account Balance

```dart
try {
  final balance = await lenco.accounts.getAccountBalance('account-id');
  print('Available: ${balance['available']}');
  print('Current: ${balance['current']}');
} on LencoNotFoundException catch (e) {
  print('Account not found: ${e.message}');
}
```

### Get Transactions

```dart
try {
  final transactions = await lenco.transactions.getTransactions(
    accountId: 'account-id',
    page: 1,
    limit: 50,
    type: 'credit', // Filter by type: 'credit' or 'debit'
    startDate: '2024-01-01T00:00:00Z',
    endDate: '2024-12-31T23:59:59Z',
  );

  for (var txn in transactions) {
    print('${txn.type}: ${txn.amount} ${txn.currency}');
    print('Description: ${txn.description}');
    print('Status: ${txn.status}');
    print('Date: ${txn.createdAt}');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Verify Account Name

Always verify account details before making a transfer:

```dart
try {
  final accountName = await lenco.payments.verifyAccountName(
    accountNumber: '1234567890',
    bankCode: '044', // Access Bank
  );

  print('Account Name: $accountName');
  // Proceed with transfer if name matches
} on LencoNotFoundException catch (e) {
  print('Account not found');
} on LencoException catch (e) {
  print('Verification failed: ${e.message}');
}
```

### Get List of Banks

```dart
try {
  final banks = await lenco.payments.getBanks();

  for (var bank in banks) {
    print('${bank.name} - ${bank.code}');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Initiate Bank Transfer

```dart
try {
  final payment = await lenco.payments.initiatePayment(
    PaymentRequest(
      accountId: 'your-account-id',
      amount: '10000', // Amount in kobo/minor units
      recipientAccountNumber: '1234567890',
      recipientBankCode: '044',
      narration: 'Payment for services',
      reference: 'TXN-${DateTime.now().millisecondsSinceEpoch}', // Optional
    ),
  );

  print('Payment Reference: ${payment.reference}');
  print('Status: ${payment.status}');
  print('Amount: ${payment.amount}');
} on LencoValidationException catch (e) {
  print('Validation Error: ${e.message}');
  print('Errors: ${e.errors}');
} on LencoAuthenticationException catch (e) {
  print('Authentication failed: ${e.message}');
} on LencoException catch (e) {
  print('Payment failed: ${e.message}');
}
```

### Check Payment Status

```dart
try {
  final payment = await lenco.payments.getPaymentStatus(
    reference: 'PAY-REF-123',
  );

  if (payment.status == 'success') {
    print('Payment completed successfully');
  } else if (payment.status == 'pending') {
    print('Payment is still processing');
  } else {
    print('Payment failed: ${payment.message}');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Bulk Transfers

```dart
try {
  final transfers = [
    PaymentRequest(
      accountId: 'account-id',
      amount: '5000',
      recipientAccountNumber: '1111111111',
      recipientBankCode: '044',
      narration: 'Salary - John',
    ),
    PaymentRequest(
      accountId: 'account-id',
      amount: '7500',
      recipientAccountNumber: '2222222222',
      recipientBankCode: '058',
      narration: 'Salary - Jane',
    ),
  ];

  final result = await lenco.payments.initiateBulkTransfer(
    accountId: 'account-id',
    transfers: transfers,
  );

  print('Bulk transfer initiated: $result');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Get Transfer Fee

```dart
try {
  final fee = await lenco.payments.getTransferFee(
    amount: '10000',
    bankCode: '044',
  );

  print('Transfer fee: $fee');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Download Statement

```dart
try {
  final downloadUrl = await lenco.transactions.downloadStatement(
    accountId: 'account-id',
    startDate: '2024-01-01T00:00:00Z',
    endDate: '2024-12-31T23:59:59Z',
    format: 'pdf', // Options: 'pdf', 'csv', 'xlsx'
  );

  print('Download statement from: $downloadUrl');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Accept Payment (Collections) - v2

Accept payments from cards or mobile money:

```dart
try {
  // Accept card payment
  final collection = await lenco.collections.createCardCollection(
    CollectionRequest(
      amount: '10000',
      currency: 'NGN',
      reference: 'ORDER-123',
      callbackUrl: 'https://yourapp.com/callback',
    ),
    cardNumber: '4532015112830366',
    expiryMonth: '12',
    expiryYear: '25',
    cvv: '123',
  );

  print('Payment authorized: ${collection.authorizationUrl}');
  print('Status: ${collection.status}');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

Or accept mobile money (v2):

```dart
try {
  final collection = await lenco.collections.createMobileMoneyCollectionV2(
    request: CollectionRequest(
      amount: '10000',
      currency: 'USD',
      reference: 'ORDER-456',
    ),
    phone: '260971234567', // MSISDN (no +)
    operator: 'mtn',       // 'airtel' | 'mtn' | 'zamtel'
    country: 'ZM',
  );

  // Submit OTP if required
  final result = await lenco.collections.submitMobileMoneyOtpV2(
    collectionId: collection.id,
    otp: '123456',
  );

  print('Payment status: ${result.status}');
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Create Virtual Account - NEW!

Create a virtual account for receiving payments:

```dart
try {
  final virtualAccount = await lenco.virtualAccounts.createVirtualAccount(
    accountName: 'John Doe',
    bvn: '12345678901', // Optional
  );

  print('Virtual Account: ${virtualAccount.accountNumber}');
  print('Account Name: ${virtualAccount.accountName}');
  print('Bank: ${virtualAccount.bank.name}');
  print('Reference: ${virtualAccount.accountReference}');

  // Get virtual account transactions
  final transactions = await lenco.virtualAccounts.getTransactions(
    accountReference: virtualAccount.accountReference,
  );
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Manage Recipients - v2

Save and reuse payment recipients:

```dart
try {
  // Create a recipient
  final recipient = await lenco.recipients.createRecipient(
    accountName: 'John Doe',
    accountNumber: '1234567890',
    bankCode: '044',
  );

  print('Recipient created: ${recipient.name}');

  // Get all recipients
  final recipients = await lenco.recipients.getRecipients();

  for (var recipient in recipients) {
    print('${recipient.name} - ${recipient.accountNumber}');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

### Track Settlements - NEW!

Monitor your settlement history:

```dart
try {
  final settlements = await lenco.settlements.getSettlements(
    page: 1,
    limit: 20,
    status: 'completed', // Optional filter
  );

  for (var settlement in settlements) {
    print('Amount: ${settlement.amount} ${settlement.currency}');
    print('Status: ${settlement.status}');
    print('Date: ${settlement.createdAt}');
  }
} on LencoException catch (e) {
  print('Error: ${e.message}');
}
```

## Error Handling

The package includes a comprehensive exception hierarchy:

```dart
try {
  await lenco.payments.initiatePayment(request);
} on LencoAuthenticationException catch (e) {
  // Handle authentication errors (401)
  print('Invalid API key: ${e.message}');
} on LencoValidationException catch (e) {
  // Handle validation errors (400)
  print('Validation failed: ${e.message}');
  print('Field errors: ${e.errors}');
} on LencoNotFoundException catch (e) {
  // Handle not found errors (404)
  print('Resource not found: ${e.message}');
} on LencoRateLimitException catch (e) {
  // Handle rate limiting (429)
  print('Too many requests: ${e.message}');
} on LencoServerException catch (e) {
  // Handle server errors (500+)
  print('Server error: ${e.message}');
} on LencoNetworkException catch (e) {
  // Handle network errors
  print('Network error: ${e.message}');
} on LencoException catch (e) {
  // Handle all other Lenco errors
  print('Lenco error: ${e.message}');
} catch (e) {
  // Handle unexpected errors
  print('Unexpected error: $e');
}
```

## Best Practices

### 1. Always Verify Account Names

```dart
// ✅ Good
final name = await lenco.payments.verifyAccountName(...);
if (name == expectedName) {
  await lenco.payments.initiatePayment(...);
}

// ❌ Bad
await lenco.payments.initiatePayment(...); // Without verification
```

### 2. Use Unique References

```dart
// ✅ Good - Generate unique references
final reference = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

// ❌ Bad - Reusing references can cause issues
final reference = 'payment-1';
```

### 3. Handle Errors Gracefully

```dart
// ✅ Good - Specific error handling
try {
  await lenco.payments.initiatePayment(...);
} on LencoValidationException catch (e) {
  // Show field-specific errors to user
} on LencoNetworkException catch (e) {
  // Show network error, retry option
}

// ❌ Bad - Generic error handling
try {
  await lenco.payments.initiatePayment(...);
} catch (e) {
  print('Error: $e');
}
```

### 4. Close the Client

```dart
// Close when done to free resources
lenco.close();
```

### 5. Use Sandbox for Testing

```dart
// ✅ Development
final lenco = LencoClient.sandbox(apiKey: testKey);

// ✅ Production
final lenco = LencoClient.production(apiKey: prodKey);
```

## Testing

The package is designed to be easily testable. You can mock the HTTP client:

```dart
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Create mock
class MockClient extends Mock implements http.Client {}

// Use in tests
final mockClient = MockClient();
final lenco = LencoClient(
  config: LencoConfig(apiKey: 'test-key'),
  httpClient: mockClient,
);
```

### Test suites

- Unit tests: cover models, utilities, error mapping and service happy-paths.
- Contract tests (v2): validate request paths and payload shapes against the docs for endpoints such as `collections`, `transfers`, `resolve`, `accounts`, `transactions`, `banks`, `settlements`, `transfer-recipients`, and `encryption-key`. See `test/v2_contract_test.dart`.

### Run tests locally

```bash
flutter test
```

### Developer notes

- Use `LencoConfig.sandbox(..., version: LencoApiVersion.v2)` in tests to ensure versioned base path `/access/v2`.
- MSISDN normalization: pass any Zambia phone format; SDK normalizes to MSISDN (e.g., `+260971234567` -> `260971234567`).
- Error handling: the HTTP client maps 4xx/5xx to specific exceptions. Assert types rather than messages.
- Reference: Lenco v2 API docs [link](https://lenco-api.readme.io/v2.0/reference/introduction).

## API Documentation

For complete API documentation, visit:

- [Lenco API v2 Documentation](https://lenco-api.readme.io/v2.0/reference/introduction)

## Support

- 📧 Email: wamunyimamukelabai3@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/wamunyima3/lenco_flutter/issues)
- 📖 Documentation: [API Docs](https://lenco-api.readme.io)

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes.

## Author

Wamunyima Mukelabai - [GitHub](https://github.com/wamunyima3)

## Acknowledgments

- Thanks to Lenco for providing the payment gateway API
- Built with ❤️ for the Flutter community
