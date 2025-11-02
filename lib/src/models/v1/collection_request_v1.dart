import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection_request_v1.g.dart';

/// v1 Mobile Money collection request payload
/// Differs from v2: phoneNumber/provider instead of phone/operator/country
@JsonSerializable()
class CollectionRequestV1 extends Equatable {
  final String amount;
  final String currency;
  final String reference;
  final String phoneNumber;
  final String provider; // e.g., 'MTN'
  final String? callbackUrl;
  final Map<String, dynamic>? metadata;

  const CollectionRequestV1({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.phoneNumber,
    required this.provider,
    this.callbackUrl,
    this.metadata,
  });

  factory CollectionRequestV1.fromJson(Map<String, dynamic> json) =>
      _$CollectionRequestV1FromJson(json);

  Map<String, dynamic> toJson() => _$CollectionRequestV1ToJson(this);

  @override
  List<Object?> get props => [
    amount,
    currency,
    reference,
    phoneNumber,
    provider,
    callbackUrl,
    metadata,
  ];

  CollectionRequestV1 copyWith({
    String? amount,
    String? currency,
    String? reference,
    String? phoneNumber,
    String? provider,
    String? callbackUrl,
    Map<String, dynamic>? metadata,
  }) {
    return CollectionRequestV1(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      provider: provider ?? this.provider,
      callbackUrl: callbackUrl ?? this.callbackUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
