import 'package:lenco_flutter/src/models/api_response.dart';

abstract class BanksRepository {
  Future<List<Bank>> getBanks();
}
