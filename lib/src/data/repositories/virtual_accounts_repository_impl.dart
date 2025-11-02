import 'package:lenco_flutter/src/data/datasources/v2/virtual_accounts_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/virtual_accounts_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class VirtualAccountsRepositoryImpl implements VirtualAccountsRepository {
  final VirtualAccountsRemoteDataSourceV2 _remoteV2;

  VirtualAccountsRepositoryImpl(this._remoteV2);

  @override
  Future<List<VirtualAccount>> getVirtualAccounts({
    int page = 1,
    int limit = 50,
  }) {
    return _remoteV2.getVirtualAccounts(page: page, limit: limit);
  }

  @override
  Future<VirtualAccount> getVirtualAccountByReference(String accountReference) {
    return _remoteV2.getVirtualAccountByReference(accountReference);
  }
}
