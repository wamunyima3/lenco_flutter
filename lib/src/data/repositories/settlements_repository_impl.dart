import 'package:lenco_flutter/src/data/datasources/v2/settlements_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/settlements_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class SettlementsRepositoryImpl implements SettlementsRepository {
  final SettlementsRemoteDataSourceV2 _remoteV2;

  SettlementsRepositoryImpl(this._remoteV2);

  @override
  Future<Settlement> getSettlementById(String settlementId) {
    return _remoteV2.getSettlementById(settlementId);
  }
}
