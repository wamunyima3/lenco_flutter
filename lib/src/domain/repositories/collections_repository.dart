import 'package:lenco_flutter/src/models/api_response.dart';

abstract class CollectionsRepository {
  Future<CollectionResponse> createMobileMoneyCollection({
    required CollectionRequest request,
    required String phone,
    required String operator,
    String country = 'ZM',
  });

  Future<CollectionResponse> submitMobileMoneyOtp({
    required String collectionId,
    required String otp,
  });

  Future<CollectionResponse> createCardCollection({
    required CollectionRequest request,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    String? cardHolderName,
  });

  Future<List<CollectionResponse>> getCollections({
    int page = 1,
    int limit = 50,
  });

  Future<CollectionResponse> getCollectionById(String id);

  Future<CollectionResponse> getCollectionStatus(String reference);
}
