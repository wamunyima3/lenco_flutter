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
  ) => _$LencoApiResponseFromJson(json, fromJsonT);

  @override
  List<Object?> get props => [status, message, data, errorCode, errors];

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$LencoApiResponseToJson(this, toJsonT);
}

/// Mobile money operator (Zambia)
enum MobileMoneyOperator { airtel, mtn, zamtel }

/// Mobile money details in v2 responses
@JsonSerializable()
class MobileMoneyDetails extends Equatable {
  final String country; // e.g., 'ZM'
  final String operator; // e.g., 'airtel' | 'mtn' | 'zamtel'
  final String phone; // MSISDN e.g., 2609XXXXXXX

  const MobileMoneyDetails({
    required this.country,
    required this.operator,
    required this.phone,
  });

  factory MobileMoneyDetails.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyDetailsToJson(this);

  @override
  List<Object?> get props => [country, operator, phone];
}

/// Extended Collection response for mobile money (v2)
@JsonSerializable()
class MobileMoneyCollectionResponse extends Equatable {
  final String id;
  final String reference;
  final String
  status; // e.g., 'otp-required', 'pay-offline', 'pending', 'success'
  final String amount;
  final String currency;
  final DateTime createdAt;
  final bool? otpRequired;
  final bool? payOffline;
  final MobileMoneyDetails? mobileMoneyDetails;
  final Map<String, dynamic>? metadata;

  const MobileMoneyCollectionResponse({
    required this.id,
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.otpRequired,
    this.payOffline,
    this.mobileMoneyDetails,
    this.metadata,
  });

  factory MobileMoneyCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$MobileMoneyCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMoneyCollectionResponseToJson(this);

  @override
  List<Object?> get props => [
    id,
    reference,
    status,
    amount,
    currency,
    createdAt,
    otpRequired,
    payOffline,
    mobileMoneyDetails,
    metadata,
  ];
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

  const Bank({required this.code, required this.name});

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

/// Virtual Account model (v1)
@JsonSerializable()
class VirtualAccount extends Equatable {
  final String accountReference;
  final String accountName;
  final String accountNumber;
  final Bank bank;
  final String status;
  final String? bvn;
  final DateTime createdAt;

  const VirtualAccount({
    required this.accountReference,
    required this.accountName,
    required this.accountNumber,
    required this.bank,
    required this.status,
    required this.createdAt,
    this.bvn,
  });

  factory VirtualAccount.fromJson(Map<String, dynamic> json) =>
      _$VirtualAccountFromJson(json);

  @override
  List<Object?> get props => [
    accountReference,
    accountName,
    accountNumber,
    bank,
    status,
    bvn,
    createdAt,
  ];

  Map<String, dynamic> toJson() => _$VirtualAccountToJson(this);
}

/// Collection request (v2)
@JsonSerializable()
class CollectionRequest extends Equatable {
  final String amount;
  final String currency;
  final String reference;
  final String? callbackUrl;
  final String? metadata;

  const CollectionRequest({
    required this.amount,
    required this.currency,
    required this.reference,
    this.callbackUrl,
    this.metadata,
  });

  factory CollectionRequest.fromJson(Map<String, dynamic> json) =>
      _$CollectionRequestFromJson(json);

  @override
  List<Object?> get props => [
    amount,
    currency,
    reference,
    callbackUrl,
    metadata,
  ];

  Map<String, dynamic> toJson() => _$CollectionRequestToJson(this);
}

/// Collection response (v2)
@JsonSerializable()
class CollectionResponse extends Equatable {
  final String id;
  final String reference;
  final String status;
  final String amount;
  final String currency;
  final DateTime createdAt;
  final String? authorizationUrl;
  final Map<String, dynamic>? metadata;

  const CollectionResponse({
    required this.id,
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.authorizationUrl,
    this.metadata,
  });

  factory CollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionResponseFromJson(json);

  @override
  List<Object?> get props => [
    id,
    reference,
    status,
    amount,
    currency,
    createdAt,
    authorizationUrl,
    metadata,
  ];

  Map<String, dynamic> toJson() => _$CollectionResponseToJson(this);
}

/// Recipient model
@JsonSerializable()
class Recipient extends Equatable {
  final String id;
  final String name;
  final String accountNumber;
  final Bank bank;
  final String type;
  final DateTime createdAt;

  const Recipient({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.bank,
    required this.type,
    required this.createdAt,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) =>
      _$RecipientFromJson(json);

  @override
  List<Object?> get props => [id, name, accountNumber, bank, type, createdAt];

  Map<String, dynamic> toJson() => _$RecipientToJson(this);
}

/// Settlement model (v2)
@JsonSerializable()
class Settlement extends Equatable {
  final String id;
  final String amount;
  final String currency;
  final String status;
  final String? reference;
  final DateTime createdAt;
  final DateTime? settledAt;

  const Settlement({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.reference,
    this.settledAt,
  });

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);

  @override
  List<Object?> get props => [
    id,
    amount,
    currency,
    status,
    reference,
    createdAt,
    settledAt,
  ];

  Map<String, dynamic> toJson() => _$SettlementToJson(this);
}

/// Webhook event model
@JsonSerializable()
class WebhookEvent extends Equatable {
  final String event;
  final String id;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  const WebhookEvent({
    required this.event,
    required this.id,
    required this.data,
    required this.createdAt,
  });

  factory WebhookEvent.fromJson(Map<String, dynamic> json) =>
      _$WebhookEventFromJson(json);

  @override
  List<Object?> get props => [event, id, data, createdAt];

  Map<String, dynamic> toJson() => _$WebhookEventToJson(this);
}
