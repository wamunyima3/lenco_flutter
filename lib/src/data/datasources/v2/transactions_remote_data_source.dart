import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/transaction_service.dart';

class TransactionsRemoteDataSourceV2 {
  final TransactionServiceV2 _service;

  TransactionsRemoteDataSourceV2(this._service);

  Future<List<LencoTransaction>> getTransactions({
    int page = 1,
    int limit = 50,
    String? startDate,
    String? endDate,
    String? type,
  }) {
    return _service.getTransactions(
      page: page,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );
  }

  Future<LencoTransaction> getTransactionById(String id) {
    return _service.getTransactionById(id);
  }
}
