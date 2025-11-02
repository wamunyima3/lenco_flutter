import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

part 'bulk_transfer_request_v1.g.dart';

/// v1 bulk transfer request used by payments/bulk-transfer
@JsonSerializable()
class BulkTransferRequestV1 extends Equatable {
  final String accountId;
  final List<PaymentRequest> transfers;

  const BulkTransferRequestV1({
    required this.accountId,
    required this.transfers,
  });

  factory BulkTransferRequestV1.fromJson(Map<String, dynamic> json) =>
      _$BulkTransferRequestV1FromJson(json);

  Map<String, dynamic> toJson() => _$BulkTransferRequestV1ToJson(this);

  @override
  List<Object?> get props => [accountId, transfers];

  BulkTransferRequestV1 copyWith({
    String? accountId,
    List<PaymentRequest>? transfers,
  }) {
    return BulkTransferRequestV1(
      accountId: accountId ?? this.accountId,
      transfers: transfers ?? this.transfers,
    );
  }
}
