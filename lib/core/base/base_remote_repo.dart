import 'package:newf/core/api_helper/caller_tag.dart';

abstract class BaseRepo {
  // void init();
  // String getTag ()=> callerTag(); // captured synchronously — always correct
}

// class ApiService {
//
//   static ApiService? _instance;
//   final String baseUrl;
//   final String token;
//
//   // Private constructor
//   ApiService._internal({required this.baseUrl, required this.token});
//
// // Factory constructor for singleton
//   factory ApiService({required String baseUrl, required String token})
//   {
//     _instance ??= ApiService._internal(baseUrl: baseUrl, token: token);
//     return _instance!;
//   }
// }