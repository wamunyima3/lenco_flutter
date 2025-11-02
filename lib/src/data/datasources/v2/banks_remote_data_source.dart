import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/banks_service.dart';

class BanksRemoteDataSourceV2 {
  final BanksServiceV2 _service;

  BanksRemoteDataSourceV2(this._service);

  Future<List<Bank>> getBanks() {
    return _service.getBanks();
  }
}
