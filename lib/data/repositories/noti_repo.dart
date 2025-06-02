import 'dart:convert';
import 'dart:io' show Platform;

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/models/data_model.dart';

import '../data_sources/remote/api_endpoint_urls.dart';
import '../data_sources/remote/api_exception.dart';
import '../models/notification_model.dart';

class NotificationRepo extends ApiClient {
  // Get list notification
  Future<NotificationModel> getListNotification(String? cursor) async {
    try {
      final queryParams = cursor != null ? {'cursor': cursor} : null;
      final response = await getRequest(
        path: ApiEndpointUrls.listNotification,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final responseData = notificationModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to get notification');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Accept share note
  Future<DataModel> acceptShareNote(String tokenId) async {
    try {
      final response = await postRequest(path: '${ApiEndpointUrls.acceptShareNote}/$tokenId');
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Accept share note failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Register FCM token
  Future<DataModel> registerFCMToken({
    required String token,
    required String deviceId,
  }) async {
    try {
      final response = await postRequest(
        path: ApiEndpointUrls.registerFcmToken,
        body: {
          'token': token,
          'device_id': deviceId,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to register FCM token');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Delete FCM token
  Future<DataModel> deleteFCMToken({
    required String token,
    required String deviceId,
  }) async {
    try {
      final response = await deleteRequest(
        path: ApiEndpointUrls.registerFcmToken,
        body: {
          'token': token,
          'device_id': deviceId,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );

      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Failed to delete FCM token');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}
