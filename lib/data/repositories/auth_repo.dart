import 'dart:convert';

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/data_sources/remote/api_endpoint_urls.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';

class AuthRepo extends ApiClient {
  AuthRepo();

  // Login with email and password
  Future<DataModel> loginWithEmailAndPassword(String email, String password) async {
    Map body = {
      "email": email,
      "password": password,
    };
    try {
      final response = await postRequest(path: ApiEndpointUrls.loginWithEmailAndPassword, body: body);
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Login failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Login with google

  // Login with facebook

  // Signup with email and password
  Future<bool> signupWithEmailAndPassword(String firstName,
      String lastName,
      String email,
      String password,) async {
    Map body = {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    };
    try {
      final response = await postRequest(path: ApiEndpointUrls.signupWithEmailAndPassword, body: body);
      if (response.statusCode == 200) {
        // Parse response and check if data is true
        final Map<String, dynamic> responseMap = response.data;
        return responseMap['data'] == true;
      } else {
        throw ApiException(message: 'Signup failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Verify Email
  Future<DataModel> verifyEmail(String email, String otp) async {
    Map body = {
      "email": email,
      "otp": otp,
    };
    try {
      final response = await postRequest(path: ApiEndpointUrls.verifyEmail, body: body);
      if(response.statusCode == 200) {
        // Parse response and check if data is true
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Verify email failed');
      }
    } on ApiException {
      rethrow;
    } catch(e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Resend Verify Email
  Future<DataModel> resendVerifyEmail(String email) async {
    Map body = {
      "email": email,
    };
    try {
      final response = await postRequest(path: ApiEndpointUrls.resendVerifyEmail, body: body);
      if(response.statusCode == 200) {
        // Parse response and check if data is true
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Resend failed');
      }
    } on ApiException {
      rethrow;
    } catch(e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Logout
  Future<DataModel> logout() async {
    try {
      final response = await postRequest(path: ApiEndpointUrls.logout);
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Logout failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}
