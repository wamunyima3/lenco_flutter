import 'package:lenco_flutter/src/client/http_client_v2.dart';
import 'package:lenco_flutter/src/config/endpoints.dart';
import 'package:lenco_flutter/src/models/api_response.dart';
import 'package:lenco_flutter/src/utils/msisdn.dart';

/// v2 Collections service
class CollectionsServiceV2 {
  final HttpClientV2 _client;

  CollectionsServiceV2(this._client);

  Future<CollectionResponse> createMobileMoneyCollection({
    required CollectionRequest request,
    required String phone,
    required String operator,
    String country = 'ZM',
  }) async {
    final msisdn = MsisdnUtils.toMsisdn(phone);
    final normalizedOperator = operator.toLowerCase();
    final body = {
      ...request.toJson(),
      'phone': msisdn,
      'operator': normalizedOperator,
      'country': country,
    };
    final response = await _client.post(
      Endpoints.collectionMobileMoney,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return CollectionResponse.fromJson(apiResponse.data!);
  }

  Future<CollectionResponse> submitMobileMoneyOtp({
    required String collectionId,
    required String otp,
  }) async {
    final body = {'id': collectionId, 'otp': otp};
    final response = await _client.post(
      Endpoints.collectionMobileMoneySubmitOtp,
      body: body,
    );
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return CollectionResponse.fromJson(apiResponse.data!);
  }

  Future<CollectionResponse> createCardCollection({
    required CollectionRequest request,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    String? cardHolderName,
  }) async {
    final body = {
      ...request.toJson(),
      'cardNumber': cardNumber,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cvv': cvv,
      if (cardHolderName != null) 'cardHolderName': cardHolderName,
    };
    final response = await _client.post(Endpoints.collectionCard, body: body);
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return CollectionResponse.fromJson(apiResponse.data!);
  }

  Future<List<CollectionResponse>> getCollections({
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _client.get(
      Endpoints.collections,
      queryParameters: {'page': page, 'limit': limit},
    );
    final apiResponse = LencoApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return apiResponse.data!
        .map(
          (json) => CollectionResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<CollectionResponse> getCollectionById(String id) async {
    final response = await _client.get(Endpoints.collectionById(id));
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return CollectionResponse.fromJson(apiResponse.data!);
  }

  Future<CollectionResponse> getCollectionStatus(String reference) async {
    final response = await _client.get(Endpoints.collectionStatus(reference));
    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }
    return CollectionResponse.fromJson(apiResponse.data!);
  }
}
