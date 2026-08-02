
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {

  AuthInterceptor({
    required this.dio,
    required this.getAccessToken,
    required this.refreshToken,
  });
  final Dio dio;
  final Future<String?> Function()? getAccessToken;
  final Future<String?> Function()? refreshToken;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
if(getAccessToken!=null){
  final token = await getAccessToken!();
  if (token != null) {
    options.headers['Authorization'] = 'Bearer $token';
  }
}

handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
     if(refreshToken!=null){
       final newToken = await refreshToken!();
       if (newToken != null) {
         err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
         final response = await dio.fetch(err.requestOptions);
         return handler.resolve(response);
       }
     }
    }
    handler.next(err);
  }
}
