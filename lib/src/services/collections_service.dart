import 'package:lenco_flutter/src/client/http_client.dart';
import 'package:lenco_flutter/src/models/api_response.dart';

/// Service for payment collections (accepting payments) - API v2
class CollectionsService {
  final LencoHttpClient _client;

  CollectionsService(this._client);

  /// Create a collection (accept payment from mobile money)
  ///
  /// Example:
  /// ```dart
  /// final collection = await lenco.collections.createMobileMoneyCollection(
  ///   CollectionRequest(
  ///     amount: '10000',
  ///     currency: 'NGN',
  ///     reference: 'TXN-123456',
  ///   ),
  ///   phoneNumber: '08012345678',
  ///   provider: 'MTN',
  /// );
  /// ```
  Future<CollectionResponse> createMobileMoneyCollection({
    required CollectionRequest request,
    required String phoneNumber,
    required String provider,
  }) async {
    final body = {
      ...request.toJson(),
      'phoneNumber': phoneNumber,
      'provider': provider,
    };

    final response = await _client.post(
      'collections/mobile-money',
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

  /// Submit OTP for mobile money collection
  ///
  /// Example:
  /// ```dart
  /// final result = await lenco.collections.submitMobileMoneyOtp(
  ///   collectionId: 'col-123',
  ///   otp: '123456',
  /// );
  /// ```
  Future<CollectionResponse> submitMobileMoneyOtp({
    required String collectionId,
    required String otp,
  }) async {
    final body = {
      'otp': otp,
    };

    final response = await _client.post(
      'collections/mobile-money/submit-otp',
      body: body,
      queryParameters: {'id': collectionId},
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

  /// Create a card collection (accept payment via card)
  ///
  /// Example:
  /// ```dart
  /// final collection = await lenco.collections.createCardCollection(
  ///   CollectionRequest(
  ///     amount: '10000',
  ///     currency: 'NGN',
  ///     reference: 'TXN-123456',
  ///   ),
  ///   cardNumber: '4532015112830366',
  ///   expiryMonth: '12',
  ///   expiryYear: '25',
  ///   cvv: '123',
  /// );
  /// ```
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

    final response = await _client.post(
      'collections/card',
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

  /// Get all collections
  ///
  /// Example:
  /// ```dart
  /// final collections = await lenco.collections.getCollections(
  ///   page: 1,
  ///   limit: 20,
  /// );
  /// ```
  Future<List<CollectionResponse>> getCollections({
    int page = 1,
    int limit = 50,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
    };

    final response = await _client.get(
      'collections',
      queryParameters: queryParams,
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
            (json) => CollectionResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Get collection by ID
  Future<CollectionResponse> getCollectionById(String collectionId) async {
    final response = await _client.get('collections/$collectionId');

    final apiResponse = LencoApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );

    if (!apiResponse.status || apiResponse.data == null) {
      throw Exception(apiResponse.message);
    }

    return CollectionResponse.fromJson(apiResponse.data!);
  }

  /// Get collection status by reference
  Future<CollectionResponse> getCollectionStatus(String reference) async {
    final response = await _client.get('collections/status/$reference');

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
