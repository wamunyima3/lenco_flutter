import 'package:lenco_flutter/src/data/datasources/v2/recipients_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/recipients_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class RecipientsRepositoryImpl implements RecipientsRepository {
  final RecipientsRemoteDataSourceV2 _remoteV2;

  RecipientsRepositoryImpl(this._remoteV2);

  @override
  Future<List<Recipient>> getRecipients() {
    return _remoteV2.getRecipients();
  }

  @override
  Future<Recipient> getRecipientById(String id) {
    return _remoteV2.getRecipientById(id);
  }
}
