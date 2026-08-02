
import 'package:dio/dio.dart';
import 'package:newf/core/shared/methods/print.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final _log = PrintHelper();

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  bool _shouldRetry(DioException err) {
    // return false;
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return true;
    }

    return false;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final int retries = int.tryParse(err.requestOptions.extra['retries']?.toString() ?? '0') ?? 0;

    if (_shouldRetry(err) && retries < maxRetries) {
      err.requestOptions.extra['retries'] = retries + 1;
      final delaySeconds = 2 * (retries + 1);

      _log.loggerPrint(
        '🔄 [RETRY] Attempt ${retries + 1}/$maxRetries in $delaySeconds seconds for ${err.requestOptions.path}',
        LoggerType.warning,
        'HTTP',
        -1,
      );

      await Future.delayed(Duration(seconds: delaySeconds));

      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        // If it fails again, we pass the new error to the next handler
        // which might trigger this interceptor again via the pipeline.
        return handler.next(e);
      }
    }

    handler.next(err);
  }
}
