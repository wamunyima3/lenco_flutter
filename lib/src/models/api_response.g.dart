// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LencoApiResponse<T> _$LencoApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    LencoApiResponse<T>(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      errorCode: json['errorCode'] as String?,
      errors: json['errors'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LencoApiResponseToJson<T>(
  LencoApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'errorCode': instance.errorCode,
      'errors': instance.errors,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

LencoAccount _$LencoAccountFromJson(Map<String, dynamic> json) => LencoAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      bankAccount:
          BankAccount.fromJson(json['bankAccount'] as Map<String, dynamic>),
      type: json['type'] as String,
      status: json['status'] as String,
      availableBalance: json['availableBalance'] as String,
      currentBalance: json['currentBalance'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$LencoAccountToJson(LencoAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bankAccount': instance.bankAccount,
      'type': instance.type,
      'status': instance.status,
      'availableBalance': instance.availableBalance,
      'currentBalance': instance.currentBalance,
      'createdAt': instance.createdAt.toIso8601String(),
      'currency': instance.currency,
    };

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      bank: Bank.fromJson(json['bank'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'bank': instance.bank,
    };

Bank _$BankFromJson(Map<String, dynamic> json) => Bank(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

LencoTransaction _$LencoTransactionFromJson(Map<String, dynamic> json) =>
    LencoTransaction(
      id: json['id'] as String,
      reference: json['reference'] as String,
      type: json['type'] as String,
      amount: json['amount'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      recipientName: json['recipientName'] as String?,
      recipientAccount: json['recipientAccount'] as String?,
    );

Map<String, dynamic> _$LencoTransactionToJson(LencoTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'recipientName': instance.recipientName,
      'recipientAccount': instance.recipientAccount,
    };

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      accountId: json['accountId'] as String,
      amount: json['amount'] as String,
      recipientAccountNumber: json['recipientAccountNumber'] as String,
      recipientBankCode: json['recipientBankCode'] as String,
      narration: json['narration'] as String?,
      reference: json['reference'] as String?,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'amount': instance.amount,
      'recipientAccountNumber': instance.recipientAccountNumber,
      'recipientBankCode': instance.recipientBankCode,
      'narration': instance.narration,
      'reference': instance.reference,
    };

PaymentResponse _$PaymentResponseFromJson(Map<String, dynamic> json) =>
    PaymentResponse(
      id: json['id'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$PaymentResponseToJson(PaymentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'status': instance.status,
      'amount': instance.amount,
      'message': instance.message,
    };
