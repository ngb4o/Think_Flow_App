import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/data_sources/remote/api_endpoint_urls.dart';
import 'package:think_flow/data/data_sources/remote/api_constant.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';

class AuthRepo extends ApiClient {
  AuthRepo();

  Future<void> setCookie(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Login with email and password
  Future<DataModel> loginWithEmailAndPassword(
      String email, String password) async {
    Map body = {
      "email": email,
      "password": password,
    };
    try {
      final response = await postRequest(
          path: ApiEndpointUrls.loginWithEmailAndPassword, body: body);
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
  Future<DataModel> loginWithGoogle() async {
    try {
      // Launch Google login URL in browser
      final Uri url =
          Uri.parse('${ApiConstant.mainUrl}${ApiEndpointUrls.loginWithGoogle}');
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw ApiException(message: 'Could not launch Google login');
      }

      // Wait for the response from the server
      final response = await getRequest(path: ApiEndpointUrls.loginWithGoogle);
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        // Save access token cookie
        if (responseData.data != null &&
            responseData.data['accessToken'] != null) {
          await setCookie('accessToken', responseData.data['accessToken']);
        }
        return responseData;
      } else {
        throw ApiException(message: 'Google login failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Login with facebook

  // Signup with email and password
  Future<bool> signupWithEmailAndPassword(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    Map body = {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    };
    try {
      final response = await postRequest(
          path: ApiEndpointUrls.signupWithEmailAndPassword, body: body);
      if (response.statusCode == 200) {
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
      final response =
          await postRequest(path: ApiEndpointUrls.verifyEmail, body: body);
      if (response.statusCode == 200) {
        // Parse response and check if data is true
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Verify email failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Resend Verify Email
  Future<DataModel> resendVerifyEmail(String email) async {
    Map body = {
      "email": email,
    };
    try {
      final response = await postRequest(
          path: ApiEndpointUrls.resendVerifyEmail, body: body);
      if (response.statusCode == 200) {
        // Parse response and check if data is true
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Resend failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
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

  // Forgot password
  Future<DataModel> forgotPassword(String email) async {
    Map body = {
      "email": email,
    };
    try {
      final response =
          await postRequest(path: ApiEndpointUrls.forgotPassword, body: body);
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Forgot password failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }

  // Reset password
  Future<DataModel> resetPassword(
      String email, String otp, String newPassword) async {
    Map body = {
      "email": email,
      "otp": otp,
      "new_password": newPassword,
    };
    try {
      final response =
          await postRequest(path: ApiEndpointUrls.resetPassword, body: body);
      if (response.statusCode == 200) {
        final responseData = dataModelFromJson(jsonEncode(response.data));
        return responseData;
      } else {
        throw ApiException(message: 'Reset password failed');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}
