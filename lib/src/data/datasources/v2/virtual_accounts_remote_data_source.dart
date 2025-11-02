import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/virtual_account_service.dart';

class VirtualAccountsRemoteDataSourceV2 {
  final VirtualAccountServiceV2 _service;

  VirtualAccountsRemoteDataSourceV2(this._service);

  Future<List<VirtualAccount>> getVirtualAccounts({
    int page = 1,
    int limit = 50,
  }) {
    return _service.getVirtualAccounts(page: page, limit: limit);
  }

  Future<VirtualAccount> getVirtualAccountByReference(String accountReference) {
    return _service.getVirtualAccountByReference(accountReference);
  }
}
