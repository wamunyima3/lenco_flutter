# Contributing to Lenco Flutter

Thank you for your interest in contributing to the Lenco Flutter package! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

## Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. Please be respectful and constructive in all interactions.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/wamunyima3/lenco_flutter.git
   cd lenco_flutter
   ```
3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/wamunyima3/lenco_flutter.git
   ```

## Development Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git

### Setup Steps

1. **Install dependencies**:

   ```bash
   flutter pub get
   cd example && flutter pub get && cd ..
   ```

2. **Generate code**:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run tests**:

   ```bash
   flutter test
   ```

4. **Run example app**:
   ```bash
   cd example && flutter run
   ```

## Making Changes

### Branch Strategy

- Create a new branch for each feature or bugfix
- Use descriptive branch names:
  - `feature/payment-webhooks`
  - `bugfix/exception-handling`
  - `docs/api-documentation`

### Code Style

- Follow Dart/Flutter style guidelines
- Use `dart format` to format code
- Follow the existing code patterns
- Add appropriate comments and documentation

### Commit Messages

Use clear, descriptive commit messages:

```
feat: add webhook support for payment notifications

- Add WebhookService class
- Implement webhook verification
- Add tests for webhook functionality
```

Common prefixes:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `test:` - Test additions or changes
- `refactor:` - Code refactoring
- `perf:` - Performance improvements

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/lenco_flutter_test.dart
```

### Writing Tests

- Write tests for all new functionality
- Aim for high test coverage
- Use descriptive test names
- Test both success and error cases
- Mock external dependencies

### Test Structure

```dart
group('FeatureName', () {
  setUp(() {
    // Setup code
  });

  test('should do something when condition', () {
    // Test implementation
  });

  test('should handle error when invalid input', () {
    // Error case test
  });
});
```

## Documentation

### Code Documentation

- Add dartdoc comments to all public APIs
- Include usage examples in documentation
- Document parameters and return values
- Explain complex logic

### Example Documentation

````dart
/// Initiates a bank transfer.
///
/// [request] - Payment request details containing account information,
/// amount, recipient details, and optional narration.
///
/// Returns a [PaymentResponse] with payment status and reference.
///
/// Throws [LencoValidationException] if request validation fails.
/// Throws [LencoAuthenticationException] if API key is invalid.
///
/// Example:
/// ```dart
/// final payment = await lenco.payments.initiatePayment(
///   PaymentRequest(
///     accountId: 'acc-123',
///     amount: '10000',
///     recipientAccountNumber: '1234567890',
///     recipientBankCode: '044',
///     narration: 'Payment for services',
///   ),
/// );
/// ```
Future<PaymentResponse> initiatePayment(PaymentRequest request);
````

### README Updates

- Update README.md for significant changes
- Add new examples and use cases
- Update installation instructions if needed
- Keep the documentation current

## Submitting Changes

### Pull Request Process

1. **Create a pull request** from your feature branch
2. **Fill out the PR template** completely
3. **Link any related issues**
4. **Request review** from maintainers

### PR Requirements

- [ ] All tests pass
- [ ] Code is properly formatted
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] CHANGELOG.md is updated
- [ ] Example app works with changes

### PR Template

```markdown
## Description

Brief description of changes

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing

- [ ] Tests pass locally
- [ ] New tests added for new functionality
- [ ] Example app tested

## Checklist

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
```

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps

1. **Update version** in `pubspec.yaml`
2. **Update CHANGELOG.md** with new version
3. **Create release branch** from main
4. **Run final tests** and quality checks
5. **Create GitHub release** with release notes
6. **Publish to pub.dev**:
   ```bash
   flutter pub publish
   ```

### Quality Checks

Before release, ensure:

- [ ] All tests pass
- [ ] Code analysis passes (`dart analyze`)
- [ ] Code is formatted (`dart format`)
- [ ] Documentation is complete
- [ ] Example app works
- [ ] No security vulnerabilities

## Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **Discussions**: For questions and general discussion
- **Email**: For security issues (use private communication)

## Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- GitHub contributors list

Thank you for contributing to Lenco Flutter! 🚀
