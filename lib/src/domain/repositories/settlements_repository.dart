import 'package:lenco_flutter/src/models/api_response.dart';

abstract class SettlementsRepository {
  Future<Settlement> getSettlementById(String settlementId);
}
