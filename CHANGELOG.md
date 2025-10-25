# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

- Webhook support
- Mobile money integration
- Enhanced error recovery
- Performance optimizations
- Additional payment methods
- Real-time transaction updates
