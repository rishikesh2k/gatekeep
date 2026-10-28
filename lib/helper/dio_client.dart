import 'package:dio/dio.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/services/api_exception.dart';

class DioClient {
  DioClient();

  final Dio dio = locator<Dio>();

  Future<dynamic> get(String path) async {
    try {
      final response = await dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await dio.put(path, data: body);
      return response.data;
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  Future<void> delete(String path) async {
    try {
      await dio.delete(path);
    } on DioException catch (e) {
      throw handleDioException(e);
    }
  }

  ApiException handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Server is taking too long to respond.', isNetworkError: true);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return ApiException('No internet connection. Please try again.', isNetworkError: true);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled.');
      case DioExceptionType.badCertificate:
        return ApiException('Secure connection failed.', isNetworkError: true);
      case DioExceptionType.transformTimeout:
        return ApiException('Invalid data received from server');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 404) return ApiException('Visitor not found', statusCode: code);
        if (code >= 500) return ApiException('Server error. Please try again later.', statusCode: code);
        return ApiException('Request failed ($code). Please try again.', statusCode: code);
    }
  }
}
