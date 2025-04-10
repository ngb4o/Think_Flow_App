import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? code;
  final String? status;
  final String? debug;

  ApiException({
    required this.message,
    this.code,
    this.status,
    this.debug,
  });

  factory ApiException.fromDioError(DioException error) {
    if (error.response?.data != null && error.response?.data is Map) {
      final Map<String, dynamic> data = error.response?.data;
      return ApiException(
        message: data['message'] ?? 'Something went wrong',
        code: data['code'],
        status: data['status'],
        debug: data['debug'],
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');
      default:
        return ApiException(message: 'Something went wrong');
    }
  }

  @override
  String toString() => message;
}