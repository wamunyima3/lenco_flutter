import 'package:lenco_flutter/src/models/api_response.dart';

/// Abstraction over transaction operations
abstract class TransactionsRepository {
  Future<List<LencoTransaction>> getTransactions({
    int page = 1,
    int limit = 50,
    String? startDate,
    String? endDate,
    String? type,
  });

  Future<LencoTransaction> getTransactionById(String id);
}
