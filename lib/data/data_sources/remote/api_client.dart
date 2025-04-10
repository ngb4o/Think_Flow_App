import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'api_constant.dart';
import 'api_exception.dart';

class ApiClient {
  late Dio dio;
  late BaseOptions baseOptions;
  late PersistCookieJar cookieJar;
  BuildContext? _context;

  ApiClient() {
    baseOptions = BaseOptions(baseUrl: ApiConstant.mainUrl);
    dio = Dio(baseOptions);
    _initCookieJar();
  }

  Future<void> _initCookieJar() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Options options = Options();

  // GET REQUEST với Cookie
  Future<Response> getRequest({required String path}) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');

      // Lấy cookie đã lưu và gán vào header
      List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(ApiConstant.mainUrl));
      String cookieHeader = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      options.headers = {
        'Cookie': cookieHeader // Gửi cookie
      };

      var response = await dio.get(path, options: options);

      debugPrint('🔥 ========== API RESPONSE ========= 🔥');
      debugPrint('Status code: ${response.statusCode.toString()}');
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }

  // POST REQUEST với Cookie
  Future<Response> postRequest({
    required String path,
    dynamic body,
  }) async {
    try {
      debugPrint('🚀 ========== API REQUEST ========= 🚀');
      debugPrint('Request url: ${baseOptions.baseUrl + path}');
      debugPrint('Body: $body');

      // Lấy cookie đã lưu và gán vào header
      List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(ApiConstant.mainUrl));
      String cookieHeader = cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      options.headers = {
        'Cookie': cookieHeader, // Gửi cookie
      };

      var response = await dio.post(
        path,
        data: body,
        options: options,
      );

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
        throw ApiException.fromDioError(e);
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
        throw ApiException(message: e.message ?? 'Something went wrong');
      }
    }
  }
}
