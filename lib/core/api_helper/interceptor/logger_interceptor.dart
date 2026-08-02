import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newf/core/shared/methods/print.dart';

/// Logs every Dio request, response, and error in debug mode.
/// Add this to DioHelper interceptors.
class LoggerInterceptor extends Interceptor {
  final _log = PrintHelper();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final headers = options.headers.entries
          .map((e) => '      ${e.key}: ${e.value}')
          .join('\n');

      final body = options.data != null
          ? '\n   └─ Body    : ${options.data}'
          : '';

      final query = options.queryParameters.isNotEmpty
          ? '\n   └─ Query   : ${options.queryParameters}'
          : '';

      final caller = options.extra['caller'] as String?;

      _log.loggerPrint(
        '🌐 SENDING REQUEST............. \n'
        '   └─ Method  : ${options.method}\n'
        '   └─ URL     : ${options.baseUrl}${options.path}$query\n'
        '   └─ Headers :\n$headers'
        '$body',
        LoggerType.warning,
        'HTTP',
        -1,
        caller,
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final raw = response.data?.toString() ?? '';
      final preview = raw.length > 500 ? '${raw.substring(0, 500)}...' : raw;
      
      final caller = response.requestOptions.extra['caller'] as String?;

      _log.loggerPrint(
        '✅ [RESPONSE]\n'
        '   └─ Status  : ${response.statusCode}\n'
        '   └─ URL     : ${response.requestOptions.baseUrl}${response.requestOptions.path}\n'
        '   └─ Size    : ${raw.length} bytes\n'
        '   └─ Preview : $preview',
        LoggerType.info,
        'HTTP',
        -1,
        caller,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final caller = err.requestOptions.extra['caller'] as String?;
      
      _log.loggerPrint(
        '💥 [ERROR]\n'
        '   └─ Method  : ${err.requestOptions.method}\n'
        '   └─ URL     : ${err.requestOptions.baseUrl}${err.requestOptions.path}\n'
        '   └─ Status  : ${err.response?.statusCode}\n'
        '   └─ Message : ${err.message}\n'
        '   └─ Data    : ${err.response?.data}',
        LoggerType.error,
        'HTTP',
        -1,
        caller,
      );
    }
    handler.next(err);
  }
}
