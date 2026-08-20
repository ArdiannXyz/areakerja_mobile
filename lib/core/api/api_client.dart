import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage.dart';
import 'api_endpoints.dart';
import 'api_interceptor.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorageService _secureStorage;

  ApiClient({
    required SecureStorageService secureStorage,
    Dio? customDio,
    String? customBaseUrl,
  }) : _secureStorage = secureStorage {
    _dio = customDio ??
        Dio(
          BaseOptions(
            baseUrl: customBaseUrl ?? ApiEndpoints.baseUrl,
            connectTimeout: ApiEndpoints.connectTimeout,
            receiveTimeout: ApiEndpoints.receiveTimeout,
            sendTimeout: ApiEndpoints.sendTimeout,
            validateStatus: (status) => status != null && status < 500,
          ),
        );

    _dio.interceptors.add(
      ApiInterceptor(
        secureStorage: _secureStorage,
        onUnauthorized: () async {
          await _secureStorage.deleteToken();
        },
      ),
    );
  }

  Dio get dio => _dio;

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Response _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      return response;
    }

    // Handle Laravel validation errors (422)
    if (statusCode == 422) {
      final responseData = response.data;
      String message = 'Data yang dimasukkan tidak valid.';
      Map<String, dynamic>? errors;

      if (responseData is Map<String, dynamic>) {
        message = responseData['message']?.toString() ?? message;
        if (responseData['errors'] is Map<String, dynamic>) {
          errors = responseData['errors'] as Map<String, dynamic>;
        }
      }

      throw ValidationException(message: message, errors: errors);
    }

    // Handle 401 Unauthorized
    if (statusCode == 401) {
      final responseData = response.data;
      String message = 'Email atau kata sandi tidak cocok.';
      if (responseData is Map<String, dynamic> && responseData['message'] != null) {
        message = responseData['message'].toString();
      }
      throw AuthException(message: message);
    }

    // Other Client / Server Errors
    final responseData = response.data;
    String message = 'Terjadi kesalahan pada server ($statusCode)';
    if (responseData is Map<String, dynamic> && responseData['message'] != null) {
      message = responseData['message'].toString();
    }

    throw ServerException(
      message: message,
      statusCode: statusCode,
      errors: responseData is Map ? responseData['errors'] : null,
    );
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        if (e.response != null) {
          try {
            _handleResponse(e.response!);
          } on Exception catch (ex) {
            return ex;
          }
        }
        return ServerException(
          message: e.message ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return const ServerException(message: 'Permintaan dibatalkan.');
      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'Sertifikat SSL tidak valid.');
      case DioExceptionType.unknown:
      default:
        return NetworkException(message: e.message ?? 'Koneksi bermasalah.');
    }
  }
}
