import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/services/v2/collections_service.dart';

class CollectionsRemoteDataSourceV2 {
  final CollectionsServiceV2 _service;

  CollectionsRemoteDataSourceV2(this._service);

  Future<CollectionResponse> createMobileMoneyCollection({
    required CollectionRequest request,
    required String phone,
    required String operator,
    String country = 'ZM',
  }) {
    return _service.createMobileMoneyCollection(
      request: request,
      phone: phone,
      operator: operator,
      country: country,
    );
  }

  Future<CollectionResponse> submitMobileMoneyOtp({
    required String collectionId,
    required String otp,
  }) {
    return _service.submitMobileMoneyOtp(collectionId: collectionId, otp: otp);
  }

  Future<CollectionResponse> createCardCollection({
    required CollectionRequest request,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    String? cardHolderName,
  }) {
    return _service.createCardCollection(
      request: request,
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      cardHolderName: cardHolderName,
    );
  }

  Future<List<CollectionResponse>> getCollections({
    int page = 1,
    int limit = 50,
  }) {
    return _service.getCollections(page: page, limit: limit);
  }

  Future<CollectionResponse> getCollectionById(String id) {
    return _service.getCollectionById(id);
  }

  Future<CollectionResponse> getCollectionStatus(String reference) {
    return _service.getCollectionStatus(reference);
  }
}
