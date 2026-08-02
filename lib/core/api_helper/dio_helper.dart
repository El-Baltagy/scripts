import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/interceptor/auth_interceptor.dart';
import 'package:newf/core/api_helper/interceptor/logger_interceptor.dart';
import 'package:newf/core/api_helper/interceptor/retry_interceptor.dart';
import 'package:newf/core/constants/app_api.dart';
import 'package:newf/core/constants/app_constant.dart';
import 'package:newf/core/storage/hive_storage.dart';
import 'package:newf/core/storage/storage_helper.dart';

class DioHelper {
  DioHelper._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          Headers.acceptHeader: 'application/json',
          Headers.contentTypeHeader: 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LoggerInterceptor(),
      AuthInterceptor(
        dio: _dio,
        getAccessToken: () async => await StorageHelper.getToken,
        refreshToken: () async => null,
      ),
      RetryInterceptor(
        dio: _dio,
        maxRetries: 3,
      ),
    ]);
  }

  static final DioHelper instance = DioHelper._();

  late final Dio _dio;

  Dio get client => _dio;

  Future<T> getData<T>({
    required String uri,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? caller,
  }) => _request<T>(
        method: 'GET',
        uri: uri,
        query: query,
        headers: headers,
        cancelToken: cancelToken,
        caller: caller,
      );

  Future<T> postData<T>({
    required String uri,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? caller,
  }) => _request<T>(
        method: 'POST',
        uri: uri,
        data: data,
        query: query,
        headers: headers,
        cancelToken: cancelToken,
        caller: caller,
      );

  // Future<T> putData<T>({
  //   required String uri,
  //   dynamic data,
  //   Map<String, dynamic>? query,
  //   Map<String, dynamic>? headers,
  //   CancelToken? cancelToken,
  //   String? caller,
  // }) => _request<T>(
  //       method: 'PUT',
  //       uri: uri,
  //       data: data,
  //       query: query,
  //       headers: headers,
  //       cancelToken: cancelToken,
  //       caller: caller,
  //     );

  Future<T> patchData<T>({
    required String uri,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? caller,
  }) => _request<T>(
        method: 'PATCH',
        uri: uri,
        data: data,
        query: query,
        headers: headers,
        cancelToken: cancelToken,
        caller: caller,
      );

  Future<T> deleteData<T>({
    required String uri,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? caller,
  }) => _request<T>(
        method: 'DELETE',
        uri: uri,
        data: data,
        query: query,
        headers: headers,
        cancelToken: cancelToken,
        caller: caller,
      );

  Future<T> _request<T>({
    required String method,
    required String uri,
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    String? caller,
  }) async {
    final response = await _dio.request<T>(
      uri,
      data: data,
      queryParameters: query,
      cancelToken: cancelToken,
      options: _options(
        method: method,
        headers: headers,
        caller: caller,
      ),
    );

    return response.data as T;
  }

  Options _options({
    required String method,
    Map<String, dynamic>? headers,
    String? caller,
  }) {
    return Options(
      method: method,
      responseType:  .plain,
      headers: {
        'lang': HiveStorage().readData(AppConstant.langCode) ?? 'en',
        ...?headers,
      },
      extra: {
        'caller': caller,
      },
    );
  }
}