import 'package:lenco_flutter/src/data/datasources/v2/transactions_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/transactions_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSourceV2 _remoteV2;

  TransactionsRepositoryImpl(this._remoteV2);

  @override
  Future<List<LencoTransaction>> getTransactions({
    int page = 1,
    int limit = 50,
    String? startDate,
    String? endDate,
    String? type,
  }) {
    return _remoteV2.getTransactions(
      page: page,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }

  @override
  Future<LencoTransaction> getTransactionById(String id) {
    return _remoteV2.getTransactionById(id);
  }
}
