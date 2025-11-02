import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/settlements_service.dart';

class SettlementsRemoteDataSourceV2 {
  final SettlementsServiceV2 _service;

  SettlementsRemoteDataSourceV2(this._service);

  Future<Settlement> getSettlementById(String settlementId) {
    return _service.getSettlementById(settlementId);
  }
}
