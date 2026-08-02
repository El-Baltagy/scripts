import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:io';

abstract class DioErrorHandler {
  static Failure handleError(DioException error) {
    Failure? failure;
    switch (error.type) {
      case DioExceptionType.cancel:
        failure=   Failure('Request was cancelled by user.');
      case DioExceptionType.connectionTimeout:
        failure=   Failure('Connection timeout.');
      case DioExceptionType.receiveTimeout:
        failure=   Failure('Receive timeout.');
      case DioExceptionType.sendTimeout:
        failure=   Failure('Send timeout.');
      case DioExceptionType.badResponse:
        failure= _handleBadResponse(error.response);
      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          failure=   Failure('No internet connection.',);
        }
        failure=   Failure('Connection error.');
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          failure=   Failure('No internet connection.');
        }
        failure=   Failure('Unexpected network error.');
      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        failure=   Failure('incorrect certificate');
    }
    return failure..error=error.error;
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) return   Failure('Unknown server error.');
    final code = response.statusCode ?? 0;
     String message = response.statusMessage ?? 'Unknown error';

    try {
      final   data = response.data is String
          ? jsonDecode(response.data as String)
           : response.data;

      message = data['message']?.toString() ?? message;

      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'] as Map<String, dynamic>;

        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            message = value.first.toString();
            break;
          }
        }

      }
    } catch (_) {
      // response.data wasn't valid JSON
    }

   final String? message2 = message;
     switch (code) {
      case 400:
        message = 'Bad request.';
        break;
      case 401:
        message = 'Unauthorized.';
        break;
      case 403:
        message = 'Forbidden.';
        break;
      case 404:
        message = 'Not found.';
        break;
        case 422:
        message = 'Unprocessable Entity';
        break;
      case 500:
        message = 'Internal server error.';
        break;
    }
//+message
    return Failure(message+(message2==null?'':'\n$message2'), code);
  }
}
class Failure {

    Failure(this.message,  [this.code,this.error,]);
  final String message;
  final int? code;
    Object?   error;
  @override
  String toString() => 'Failure(code: $code, message: $message)';
}
