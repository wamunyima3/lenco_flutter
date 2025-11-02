import 'package:lenco_flutter/src/data/datasources/v2/collections_remote_data_source.dart';
import 'package:lenco_flutter/src/domain/repositories/collections_repository.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  final CollectionsRemoteDataSourceV2 _remoteV2;

  CollectionsRepositoryImpl(this._remoteV2);

  @override
  Future<CollectionResponse> createMobileMoneyCollection({
    required CollectionRequest request,
    required String phone,
    required String operator,
    String country = 'ZM',
  }) {
    return _remoteV2.createMobileMoneyCollection(
      request: request,
      phone: phone,
      operator: operator,
      country: country,
    );
  }

  @override
  Future<CollectionResponse> submitMobileMoneyOtp({
    required String collectionId,
    required String otp,
  }) {
    return _remoteV2.submitMobileMoneyOtp(collectionId: collectionId, otp: otp);
  }

  @override
  Future<CollectionResponse> createCardCollection({
    required CollectionRequest request,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    String? cardHolderName,
  }) {
    return _remoteV2.createCardCollection(
      request: request,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );
  }

  @override
  Future<List<CollectionResponse>> getCollections({
    int page = 1,
    int limit = 50,
  }) {
    return _remoteV2.getCollections(page: page, limit: limit);
  }

  @override
  Future<CollectionResponse> getCollectionById(String id) {
    return _remoteV2.getCollectionById(id);
  }

  @override
  Future<CollectionResponse> getCollectionStatus(String reference) {
    return _remoteV2.getCollectionStatus(reference);
  }
}
