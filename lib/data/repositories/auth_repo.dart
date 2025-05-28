import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:think_flow/data/data_sources/remote/api_client.dart';
import 'package:think_flow/data/data_sources/remote/api_endpoint_urls.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/utils/utils.dart';

class AuthRepo extends ApiClient {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthRepo();

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
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw ApiException(message: 'Google sign in was cancelled');
      }

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print(googleAuth.accessToken);
        
      if (googleAuth.accessToken == null) {
        throw ApiException(message: 'Failed to get access token from Google');
      }

      // Send the token to your backend
      final response = await postRequest(
        path: ApiEndpointUrls.loginWithGoogle,
        body: {
          'access_token': googleAuth.accessToken,
        },
      );

      if (response.statusCode == 200) {
        // The response is the access token string directly
        final accessToken = response.data.toString();
        await Utils.saveCookie(accessToken);
        
        // Create a DataModel with the access token
        return DataModel(data: accessToken);
      } else {
        throw ApiException(message: 'Google login failed: ${response.statusCode}');
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      print(e.toString());
      throw ApiException(message: e.toString());
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
