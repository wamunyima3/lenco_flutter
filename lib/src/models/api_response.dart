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

  MobileMoneyDetails copyWith({
    String? country,
    String? operator,
    String? phone,
  }) {
    return MobileMoneyDetails(
      country: country ?? this.country,
      operator: operator ?? this.operator,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() =>
      'MobileMoneyDetails(country: $country, operator: $operator, phone: $phone)';
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

  MobileMoneyCollectionResponse copyWith({
    String? id,
    String? reference,
    String? status,
    String? amount,
    String? currency,
    DateTime? createdAt,
    bool? otpRequired,
    bool? payOffline,
    MobileMoneyDetails? mobileMoneyDetails,
    Map<String, dynamic>? metadata,
  }) {
    return MobileMoneyCollectionResponse(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      otpRequired: otpRequired ?? this.otpRequired,
      payOffline: payOffline ?? this.payOffline,
      mobileMoneyDetails: mobileMoneyDetails ?? this.mobileMoneyDetails,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() =>
      'MobileMoneyCollectionResponse(id: $id, reference: $reference, status: $status, amount: $amount, currency: $currency)';
}

/// Account model
@JsonSerializable()
class LencoAccount extends Equatable {
  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(fromJson: _bankAccountFromJson)
  final BankAccount bankAccount;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: '0')
  final String availableBalance;
  @JsonKey(defaultValue: '0')
  final String currentBalance;
  final DateTime createdAt;
  final String
  currency; // Currency from API (may differ from request due to API conversion)

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

  static BankAccount _bankAccountFromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Return a default BankAccount if null
      return const BankAccount(
        accountName: '',
        accountNumber: '',
        bank: Bank(code: '', name: ''),
      );
    }
    return BankAccount.fromJson(json);
  }

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

  LencoAccount copyWith({
    String? id,
    String? name,
    BankAccount? bankAccount,
    String? type,
    String? status,
    String? availableBalance,
    String? currentBalance,
    DateTime? createdAt,
    String? currency,
  }) {
    return LencoAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      bankAccount: bankAccount ?? this.bankAccount,
      type: type ?? this.type,
      status: status ?? this.status,
      availableBalance: availableBalance ?? this.availableBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      createdAt: createdAt ?? this.createdAt,
      currency: currency ?? this.currency,
    );
  }

  @override
  String toString() =>
      'LencoAccount(id: $id, name: $name, currency: $currency)';
}

/// Bank account details
@JsonSerializable()
class BankAccount extends Equatable {
  @JsonKey(defaultValue: '')
  final String accountName;
  @JsonKey(defaultValue: '')
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

  BankAccount copyWith({
    String? accountName,
    String? accountNumber,
    Bank? bank,
  }) {
    return BankAccount(
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
    );
  }

  @override
  String toString() =>
      'BankAccount(accountName: $accountName, accountNumber: $accountNumber, bank: ${bank.name})';
}

/// Bank model
@JsonSerializable()
class Bank extends Equatable {
  @JsonKey(defaultValue: '')
  final String code;
  @JsonKey(defaultValue: '')
  final String name;

  const Bank({required this.code, required this.name});

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  @override
  List<Object?> get props => [code, name];

  Map<String, dynamic> toJson() => _$BankToJson(this);

  Bank copyWith({String? code, String? name}) {
    return Bank(code: code ?? this.code, name: name ?? this.name);
  }

  @override
  String toString() => 'Bank(code: $code, name: $name)';
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

  LencoTransaction copyWith({
    String? id,
    String? reference,
    String? type,
    String? amount,
    String? currency,
    String? status,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
    String? recipientName,
    String? recipientAccount,
  }) {
    return LencoTransaction(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
    );
  }

  @override
  String toString() =>
      'LencoTransaction(id: $id, reference: $reference, status: $status, amount: $amount)';
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

  PaymentRequest copyWith({
    String? accountId,
    String? amount,
    String? recipientAccountNumber,
    String? recipientBankCode,
    String? narration,
    String? reference,
  }) {
    return PaymentRequest(
      accountId: accountId ?? this.accountId,
      amount: amount ?? this.amount,
      recipientAccountNumber:
          recipientAccountNumber ?? this.recipientAccountNumber,
      recipientBankCode: recipientBankCode ?? this.recipientBankCode,
      narration: narration ?? this.narration,
      reference: reference ?? this.reference,
    );
  }

  @override
  String toString() =>
      'PaymentRequest(accountId: $accountId, amount: $amount, recipientBankCode: $recipientBankCode)';
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

  PaymentResponse copyWith({
    String? id,
    String? reference,
    String? status,
    String? amount,
    String? message,
  }) {
    return PaymentResponse(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'PaymentResponse(id: $id, reference: $reference, status: $status, amount: $amount)';
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

  VirtualAccount copyWith({
    String? accountReference,
    String? accountName,
    String? accountNumber,
    Bank? bank,
    String? status,
    String? bvn,
    DateTime? createdAt,
  }) {
    return VirtualAccount(
      accountReference: accountReference ?? this.accountReference,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      bvn: bvn ?? this.bvn,
    );
  }

  @override
  String toString() =>
      'VirtualAccount(reference: $accountReference, number: $accountNumber, bank: ${bank.name})';
}

/// Collection request (v2)
@JsonSerializable()
class CollectionRequest extends Equatable {
  final String amount;
  final String currency;
  final String reference;
  final String? callbackUrl;
  final Map<String, dynamic>? metadata;

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

  CollectionRequest copyWith({
    String? amount,
    String? currency,
    String? reference,
    String? callbackUrl,
    Map<String, dynamic>? metadata,
  }) {
    return CollectionRequest(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() =>
      'CollectionRequest(amount: $amount, currency: $currency, reference: $reference)';
}

/// Collection response (v2)
@JsonSerializable()
class CollectionResponse extends Equatable {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String reference;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: '0')
  final String amount;
  final String
  currency; // Currency from API (may be converted from request currency)
  @JsonKey(fromJson: _dateTimeFromJson)
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

  static DateTime _dateTimeFromJson(dynamic json) {
    if (json == null) return DateTime.now();
    if (json is String) {
      try {
        return DateTime.parse(json);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

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

  CollectionResponse copyWith({
    String? id,
    String? reference,
    String? status,
    String? amount,
    String? currency,
    DateTime? createdAt,
    String? authorizationUrl,
    Map<String, dynamic>? metadata,
  }) {
    return CollectionResponse(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      authorizationUrl: authorizationUrl ?? this.authorizationUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() =>
      'CollectionResponse(id: $id, reference: $reference, status: $status, amount: $amount)';
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

  Recipient copyWith({
    String? id,
    String? name,
    String? accountNumber,
    Bank? bank,
    String? type,
    DateTime? createdAt,
  }) {
    return Recipient(
      id: id ?? this.id,
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'Recipient(id: $id, name: $name, bank: ${bank.name})';
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

  Settlement copyWith({
    String? id,
    String? amount,
    String? currency,
    String? status,
    String? reference,
    DateTime? createdAt,
    DateTime? settledAt,
  }) {
    return Settlement(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      settledAt: settledAt ?? this.settledAt,
    );
  }

  @override
  String toString() => 'Settlement(id: $id, status: $status, amount: $amount)';
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

  WebhookEvent copyWith({
    String? event,
    String? id,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return WebhookEvent(
      event: event ?? this.event,
      id: id ?? this.id,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'WebhookEvent(event: $event, id: $id)';
}
