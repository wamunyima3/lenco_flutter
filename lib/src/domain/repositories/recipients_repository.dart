import 'package:lenco_flutter/src/models/api_response.dart';

abstract class RecipientsRepository {
  Future<List<Recipient>> getRecipients();
  Future<Recipient> getRecipientById(String id);
}
