import 'package:lenco_flutter/src/data/datasources/v2/banks_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/banks_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class BanksRepositoryImpl implements BanksRepository {
  final BanksRemoteDataSourceV2 _remoteV2;

  BanksRepositoryImpl(this._remoteV2);

  @override
  Future<List<Bank>> getBanks() {
    return _remoteV2.getBanks();
  }
}
