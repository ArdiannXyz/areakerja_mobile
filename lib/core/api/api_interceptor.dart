import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final VoidCallback? onUnauthorized;

  ApiInterceptor({
    required SecureStorageService secureStorage,
    this.onUnauthorized,
  }) : _secureStorage = secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (kDebugMode) {
      debugPrint('--> ${options.method.toUpperCase()} ${options.uri}');
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ${response.statusCode} ${response.requestOptions.uri}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('Error Data: ${err.response?.data}');
    }

    if (err.response?.statusCode == 401) {
      onUnauthorized?.call();
    }

    return handler.next(err);
  }
}
