# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.3.1] - 2025-01-14

### Fixed

- Fixed lint warning in `log_sanitizer.dart` by escaping angle brackets in documentation comment

## [2.3.0] - 2025-11-02

### Changed

- **v2 API as default**: `LencoApiVersion.v2` is now the default version
- **Client structure**: Primary service properties (e.g., `lenco.accounts`, `lenco.payments`) now use v2 services by default
- **V1 access**: V1 services are available via `*V1` properties (e.g., `lenco.accountsV1`) for backward compatibility
- **Model improvements**: Removed misleading default currency values, added proper null handling for API responses
- **Documentation**: Updated README examples to reflect v2 methods and current SDK state

### Fixed

- Unused import in `CollectionsServiceV2`
- Print statement replaced with proper logger usage in `AccountServiceV2`
- Currency field handling: API may convert currencies (e.g., USD to ZMW) - now properly documented

### Notes

- Mobile money collections may show currency conversion in API responses (e.g., USD request returns ZMW)
- This is expected Lenco API behavior based on account default currency and regional restrictions

## [2.2.0] - 2025-10-30

### Added

- Clean Architecture layers: domain repositories, v2 data sources, repository implementations
- HTTP client retries with backoff and request/response interceptors
- v1-specific models where payloads differ; copyWith/toString for all models
- v2 services validation, MSISDN normalization, endpoints via constants
- Docs: architecture overview, error handling guide; README config and troubleshooting
- Example app: v2 collections (mobile money + OTP), recipients, settlements
- Tests: MSISDN utils, HTTP retry/interceptor; expanded v2 contract tests
- **Security**: Log sanitization utilities, security best practices guide
- **Performance**: Bank list caching (1 hour TTL) to reduce API calls
- **WASM Support**: Cross-platform exception handling for web/WASM compatibility
- **Pub.dev Compliance**: Full platform support, conditional imports, comprehensive documentation

### Changed

- Standardized base URL construction via `LencoConfig.versionedBaseUrl`
- Pagination consistency across list endpoints
- **Security**: Added security warnings in API key documentation
- **Performance**: Implemented simple in-memory cache for frequently accessed data

### Fixed

- Missing `FutureOr` import in `LencoConfig`
- Virtual accounts service pagination parameters
- Code formatting across all source files
- Static analysis errors (only info-level warnings remain)

## [2.0.2] - 2025-01-31

### Fixed

- **Code formatting** - Applied dart format to all source files for consistency

## [2.0.1] - 2025-01-31

### Fixed

- **Static analysis issues** - Resolved all pub.dev analysis errors
  - Included generated files in published package
  - Updated SDK constraints to ^3.8.0
  - Updated json_annotation to ^4.9.0
- **Package publishing** - Package now passes all pub.dev checks

## [2.0.0] - 2025-01-31

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
