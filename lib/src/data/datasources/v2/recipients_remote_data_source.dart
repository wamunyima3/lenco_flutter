import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/recipient_service.dart';

class RecipientsRemoteDataSourceV2 {
  final RecipientServiceV2 _service;

  RecipientsRemoteDataSourceV2(this._service);

  Future<List<Recipient>> getRecipients() {
    return _service.getRecipients();
  }

  Future<Recipient> getRecipientById(String id) {
    return _service.getRecipientById(id);
  }
}
