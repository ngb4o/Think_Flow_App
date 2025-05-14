import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';

import '../../../presentation/router/router_imports.gr.dart';
import '../../../utils/utils.dart';
import 'api_constant.dart';
import 'api_exception.dart';

class ApiClient {
  late Dio dio;
  late BaseOptions baseOptions;

  ApiClient() {
    baseOptions = BaseOptions(baseUrl: ApiConstant.mainUrl);
    dio = Dio(baseOptions);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final cookie = await Utils.getCookie();
        if (cookie != null) {
          options.headers["Cookie"] = cookie;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        final cookies = response.headers.map['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          await Utils.saveCookie(cookies.join("; "));
        }
        return handler.next(response);
      },
    ));
  }

  void _handleUnauthorizedError(BuildContext? context) {
    Utils.clearAllSavedData();
    if (context != null) {
      AutoRouter.of(context).replace(LoginScreenRoute());
    }
  }

  // GET REQUEST
  Future<Response> getRequest({
    required String path,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
  }) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');
      if (queryParameters != null) {
        debugPrint('Query parameters: $queryParameters');
      }

      var response = await dio.get(
        path,
        queryParameters: queryParameters,
      );

      debugPrint('🔥 ========== API RESPONSE ========= 🔥');
      debugPrint('Status code: ${response.statusCode.toString()}');

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        
        if (e.response?.statusCode == 401) {
          _handleUnauthorizedError(context);
        }
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }

  // POST REQUEST
  Future<Response> postRequest({
    required String path,
    dynamic body,
    BuildContext? context,
  }) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');
      debugPrint('Body: $body');

      var response = await dio.post(path, data: body);

      debugPrint('🔥 ========== API RESPONSE ========= 🔥');
      debugPrint('Status code: ${response.statusCode.toString()}');
      debugPrint('Response data: ${response.data.toString()}');
      debugPrint('Response headers: ${response.headers.toString()}');

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('❌ ========== API ERROR RESPONSE ========= ❌');
        debugPrint('Error Status code: ${e.response?.statusCode}');
        debugPrint('Error Data: ${e.response?.data}');
        debugPrint('Error Headers: ${e.response?.headers}');
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        
        if (e.response?.statusCode == 401) {
          _handleUnauthorizedError(context);
        }
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }

  Future<Response> patchRequest({
    required String path,
    dynamic body,
    BuildContext? context,
  }) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');
      debugPrint('Body: $body');

      var response = await dio.patch(path, data: body);

      debugPrint('🔥 ========== API RESPONSE ========= 🔥');
      debugPrint('Status code: ${response.statusCode.toString()}');
      debugPrint('Response data: ${response.data.toString()}');
      debugPrint('Response headers: ${response.headers.toString()}');

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('❌ ========== API ERROR RESPONSE ========= ❌');
        debugPrint('Error Status code: ${e.response?.statusCode}');
        debugPrint('Error Data: ${e.response?.data}');
        debugPrint('Error Headers: ${e.response?.headers}');
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        
        if (e.response?.statusCode == 401) {
          _handleUnauthorizedError(context);
        }
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }

  // DELETE REQUEST
  Future<Response> deleteRequest({
    required String path,
    BuildContext? context,
  }) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');

      var response = await dio.delete(path);

      debugPrint('🔥 ========== API RESPONSE ========= 🔥');
      debugPrint('Status code: ${response.statusCode.toString()}');
      debugPrint('Response data: ${response.data.toString()}');
      debugPrint('Response headers: ${response.headers.toString()}');

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('❌ ========== API ERROR RESPONSE ========= ❌');
        debugPrint('Error Status code: ${e.response?.statusCode}');
        debugPrint('Error Data: ${e.response?.data}');
        debugPrint('Error Headers: ${e.response?.headers}');
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        
        if (e.response?.statusCode == 401) {
          _handleUnauthorizedError(context);
        }
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }
}
