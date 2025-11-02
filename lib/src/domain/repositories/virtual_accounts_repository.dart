import 'package:lenco_flutter/src/models/api_response.dart';

abstract class VirtualAccountsRepository {
  Future<List<VirtualAccount>> getVirtualAccounts({
    int page = 1,
    int limit = 50,
  });
  Future<VirtualAccount> getVirtualAccountByReference(String accountReference);
}
