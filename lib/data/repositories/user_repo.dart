
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/data_sources/remote/api_endpoint_urls.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/data_model.dart';

import '../models/user_model.dart';

class UserRepo extends ApiClient {
  UserRepo();

  // Get user profile
  Future<UserModel> getUserProfile() async {
    try {
      final response = await getRequest(path: ApiEndpointUrls.userProfile);
      if(response.statusCode == 200) {
        final responseData = userModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Get user profile failed');
      }
    } on ApiException {
      rethrow;
    } catch(e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Create image
  Future<DataModel> createImage(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
      });

      final response = await postRequest(
        path: ApiEndpointUrls.image,
        body: formData,
      );

      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Create image failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Update profile
  Future<DataModel> updateAvatar(String avatarId) async {
    Map body = {
      "avatar_id": avatarId,
    };
    try {
      final response = await patchRequest(
        path: ApiEndpointUrls.userProfile,
        body: body,
      );
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Update avatar failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}