import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:newf/core/shared/methods/print.dart';
import 'package:newf/core/api_helper/dio_error_handler.dart';

// Threshold for background processing: 100KB
const int threshold = 100 * 1024;
/// Handles the API response by potentially offloading heavy JSON parsing 
/// and model mapping to a background isolate.

/// Pass [caller] from the call site using [_callerTag()] so async frames
/// don't hide the real repo method.
Future<Either<Failure, T>> handleResponse<T>({
  required Future<dynamic> onCallData,
  required T Function(Map<String, dynamic> map) asObject,
String? caller,
 }) async {
  try {
    final dynamic data = await onCallData;

    final String jsonString = data is String ? data : data.toString();
    final int size = jsonString.length;


    final T result;
    if (size > threshold) {
      result = await compute(_parseAndMapIsolate<T>, _ParseParams<T>(jsonString, asObject));
    } else {
      final Map<String, dynamic> jsonMap = _ensureMap(jsonString);
      result = asObject(jsonMap);
    }

    return right(result);
  } on DioException catch (e) {
    // DioException is already logged by LoggerInterceptor.
    return left(DioErrorHandler.handleError(e));
  } catch (e, s) {
    PrintHelper().loggerPrint(
      '⚠️ [PARSE ERROR]\n   └─ Error: $e\n   └─ Stack: ${s.toString().split('\n').take(3).join('\n')}',
      LoggerType.fatal,
      caller,
       0,
    );
    return left(Failure('Format Error or Unknown Error: $e', -2));
  }
}

/// Helper function for isolate execution
T _parseAndMapIsolate<T>(_ParseParams<T> params) {
  final Map<String, dynamic> jsonMap = _ensureMap(params.jsonString);
  return params.asObject(jsonMap);
}

/// Ensures the input is converted to a Map
Map<String, dynamic> _ensureMap(String jsonString) {
  final decoded = jsonDecode(jsonString);
  if (decoded is Map<String, dynamic>) return decoded;
  // if (decoded is List) return {'data': decoded};
  return {'data': decoded};
}

/// Parameters for isolate communication
class _ParseParams<T> {
  _ParseParams(this.jsonString, this.asObject);
  final String jsonString;
  final T Function(Map<String, dynamic> map) asObject;
}
