import 'package:dio/dio.dart';

enum ApiErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  transformTimeout,
  noInternet,
  cancelled,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimit,
  server,
  badResponse,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
    this.errors,
  });

  final String message;
  final ApiErrorType type;
  final int? statusCode;
  final dynamic errors;

  factory ApiException.fromDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;

    String? serverMessage;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message is String && message.trim().isNotEmpty) {
        serverMessage = message;
      }
    }

    final errorType = switch (exception.type) {
      DioExceptionType.connectionTimeout => ApiErrorType.connectionTimeout,
      DioExceptionType.sendTimeout => ApiErrorType.sendTimeout,
      DioExceptionType.receiveTimeout => ApiErrorType.receiveTimeout,
      DioExceptionType.transformTimeout => ApiErrorType.transformTimeout,
      DioExceptionType.connectionError => ApiErrorType.noInternet,
      DioExceptionType.cancel => ApiErrorType.cancelled,
      DioExceptionType.badCertificate => ApiErrorType.badResponse,
      DioExceptionType.badResponse => _typeFromStatusCode(statusCode),
      DioExceptionType.unknown => ApiErrorType.unknown,
    };

    final fallbackMessage = switch (errorType) {
      ApiErrorType.connectionTimeout =>
        'Connection timed out. Please try again.',
      ApiErrorType.sendTimeout => 'Request timed out. Please try again.',
      ApiErrorType.receiveTimeout => 'Server took too long to respond.',
      ApiErrorType.transformTimeout =>
        'Response processing timed out. Please try again.',
      ApiErrorType.noInternet =>
        'Unable to connect. Check your internet connection.',
      ApiErrorType.cancelled => 'Request was cancelled.',
      ApiErrorType.unauthorized =>
        'Your session has expired. Please sign in again.',
      ApiErrorType.forbidden =>
        'You do not have permission to perform this action.',
      ApiErrorType.notFound => 'The requested resource was not found.',
      ApiErrorType.validation => 'Please check the submitted information.',
      ApiErrorType.rateLimit => 'Too many requests. Please try again later.',
      ApiErrorType.server =>
        'Server is temporarily unavailable. Please try again.',
      ApiErrorType.badResponse => 'Request failed. Please try again.',
      ApiErrorType.unknown => 'Something went wrong. Please try again.',
    };

    return ApiException(
      message: serverMessage ?? fallbackMessage,
      type: errorType,
      statusCode: statusCode,
      errors: responseData is Map ? responseData['errors'] : null,
    );
  }


  static ApiErrorType _typeFromStatusCode(int? statusCode) {
    if (statusCode == null) {
      return ApiErrorType.badResponse;
    }

    return switch (statusCode) {
      400 || 422 => ApiErrorType.validation,
      401 => ApiErrorType.unauthorized,
      403 => ApiErrorType.forbidden,
      404 => ApiErrorType.notFound,
      408 => ApiErrorType.receiveTimeout,
      429 => ApiErrorType.rateLimit,
      >= 500 => ApiErrorType.server,
      _ => ApiErrorType.badResponse,
    };
  }


  @override
  String toString() => message;
}
