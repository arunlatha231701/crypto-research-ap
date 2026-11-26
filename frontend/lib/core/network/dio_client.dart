import 'package:dio/dio.dart';

import '../constants/app_config.dart';
import 'api_interceptor.dart';

class DioClient {
  DioClient({TokenLoader? tokenLoader}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(ApiInterceptor(tokenLoader: tokenLoader));
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
