
import 'dart:convert';

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/data_sources/remote/api_endpoint_urls.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';

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
}