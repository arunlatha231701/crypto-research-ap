import 'package:dio/dio.dart';

import 'api_exception.dart';

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleRequest(
      () => _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _handleRequest(
      () => _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _handleRequest(
      () => _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> _handleRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
