# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-XX

### Added

- **Collections Service** - Accept payments from customers
  - Card payment collections
  - Mobile money collections
  - OTP submission for mobile money
  - Collection status tracking
- **Virtual Accounts Service** - Receive payments via dedicated accounts
  - Create virtual accounts
  - Get virtual accounts by reference or BVN
  - Fetch virtual account transactions
  - Get rejected transactions
- **Recipient Service** - Manage payment recipients
  - Create recipients
  - Get all recipients
  - Get recipient by ID
- **Settlements Service** - Track payouts and settlements
  - Get all settlements
  - Filter settlements by status
  - Get settlement by ID
- **New Models**
  - `VirtualAccount` - Virtual account data model
  - `CollectionRequest` & `CollectionResponse` - Collection models
  - `Recipient` - Recipient model
  - `Settlement` - Settlement model
  - `WebhookEvent` - Webhook event model

### Changed

- Updated `LencoClient` to include 4 new services
- Enhanced package to be a complete payment gateway (accept + send payments)
- Updated README with new feature examples

### Notes

This is a major version upgrade that transforms the package from a "send money" tool to a complete payment gateway with both acceptance and disbursement capabilities.

## [1.0.0] - 2025-10-31

### Added

- Initial release of Lenco Flutter package
- Complete Lenco API integration
- Account management functionality
  - Get all accounts
  - Get account by ID
  - Get account balance
- Transaction management functionality
  - Get transactions with filtering and pagination
  - Get transaction by ID
  - Get transaction by reference
  - Download transaction statements
- Payment functionality
  - Initiate bank transfers
  - Verify account names
  - Get supported banks
  - Get payment status
  - Bulk transfer support
  - Transfer fee calculation
- Comprehensive error handling with specific exception types
- JSON serialization for all models
- Production and sandbox environment support
- Extensive test coverage
- Example Flutter application
- Complete documentation

### Features

- **LencoClient**: Main client for API interactions
- **AccountService**: Account-related operations
- **TransactionService**: Transaction management
- **PaymentService**: Payment operations
- **LencoConfig**: Configuration management
- **Exception Handling**: Comprehensive error handling
- **Models**: Complete data models with JSON serialization

### Technical Details

- Dart SDK: >=3.0.0 <4.0.0
- Flutter SDK: >=3.0.0
- HTTP client with timeout and retry logic
- Type-safe API responses
- Comprehensive logging support
- Mock support for testing

### Documentation

- Complete API documentation
- Usage examples
- Error handling guide
- Best practices
- Contributing guidelines
- MIT License

## [Unreleased]

### Planned Features

- Point of Sale (POS) support
- Bill payments integration
- Enhanced webhook management
- Performance optimizations
- Additional payment methods
