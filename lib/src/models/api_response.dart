import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response wrapper
@JsonSerializable(genericArgumentFactories: true)
class LencoApiResponse<T> extends Equatable {
  final bool status;
  final String message;
  final T? data;
  final String? errorCode;
  final Map<String, dynamic>? errors;

  const LencoApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.errorCode,
    this.errors,
  });

  factory LencoApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$LencoApiResponseFromJson(json, fromJsonT);

  @override
  List<Object?> get props => [status, message, data, errorCode, errors];

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$LencoApiResponseToJson(this, toJsonT);
}

/// Account model
@JsonSerializable()
class LencoAccount extends Equatable {
  final String id;
  final String name;
  final BankAccount bankAccount;
  final String type;
  final String status;
  final String availableBalance;
  final String currentBalance;
  final DateTime createdAt;
  final String currency;

  const LencoAccount({
    required this.id,
    required this.name,
    required this.bankAccount,
    required this.type,
    required this.status,
    required this.availableBalance,
    required this.currentBalance,
    required this.createdAt,
    required this.currency,
  });

  factory LencoAccount.fromJson(Map<String, dynamic> json) =>
      _$LencoAccountFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        bankAccount,
        type,
        status,
        availableBalance,
        currentBalance,
        createdAt,
        currency,
      ];

  Map<String, dynamic> toJson() => _$LencoAccountToJson(this);
}

/// Bank account details
@JsonSerializable()
class BankAccount extends Equatable {
  final String accountName;
  final String accountNumber;
  final Bank bank;

  const BankAccount({
    required this.accountName,
    required this.accountNumber,
    required this.bank,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) =>
      _$BankAccountFromJson(json);

  @override
  List<Object?> get props => [accountName, accountNumber, bank];

  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}

/// Bank model
@JsonSerializable()
class Bank extends Equatable {
  final String code;
  final String name;

  const Bank({
    required this.code,
    required this.name,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  @override
  List<Object?> get props => [code, name];

  Map<String, dynamic> toJson() => _$BankToJson(this);
}

/// Transaction model
@JsonSerializable()
class LencoTransaction extends Equatable {
  final String id;
  final String reference;
  final String type;
  final String amount;
  final String currency;
  final String status;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? recipientName;
  final String? recipientAccount;

  const LencoTransaction({
    required this.id,
    required this.reference,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
    required this.createdAt,
    this.completedAt,
    this.recipientName,
    this.recipientAccount,
  });

  factory LencoTransaction.fromJson(Map<String, dynamic> json) =>
      _$LencoTransactionFromJson(json);

  @override
  List<Object?> get props => [
        id,
        reference,
        type,
        amount,
        currency,
        status,
        description,
        createdAt,
        completedAt,
        recipientName,
        recipientAccount,
      ];

  Map<String, dynamic> toJson() => _$LencoTransactionToJson(this);
}

/// Payment request model
@JsonSerializable()
class PaymentRequest extends Equatable {
  final String accountId;
  final String amount;
  final String recipientAccountNumber;
  final String recipientBankCode;
  final String? narration;
  final String? reference;

  const PaymentRequest({
    required this.accountId,
    required this.amount,
    required this.recipientAccountNumber,
    required this.recipientBankCode,
    this.narration,
    this.reference,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  @override
  List<Object?> get props => [
        accountId,
        amount,
        recipientAccountNumber,
        recipientBankCode,
        narration,
        reference,
      ];

  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

/// Payment response model
@JsonSerializable()
class PaymentResponse extends Equatable {
  final String id;
  final String reference;
  final String status;
  final String amount;
  final String? message;

  const PaymentResponse({
    required this.id,
    required this.reference,
    required this.status,
    required this.amount,
    this.message,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);

  @override
  List<Object?> get props => [id, reference, status, amount, message];

  Map<String, dynamic> toJson() => _$PaymentResponseToJson(this);
}
