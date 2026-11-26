
import 'package:dio/dio.dart';

typedef TokenLoader = Future<String?> Function();

class ApiInterceptor extends Interceptor {
  ApiInterceptor({TokenLoader? tokenLoader})
      : _tokenLoader = tokenLoader;

  final TokenLoader? _tokenLoader;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final token = await _tokenLoader?.call();

      // Prevent accidentally sending a stale token.
      options.headers.remove('Authorization');

      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] =
        'Token ${token.trim()}';
      }

      // Preserve any explicitly configured Accept header.
      options.headers.putIfAbsent(
        'Accept',
            () => 'application/json',
      );

      handler.next(options);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
          type: DioExceptionType.unknown,
          message: 'Unable to retrieve authentication token.',
        ),
      );
    }
  }

  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {
    handler.next(response);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    handler.next(err);
  }
}
