import 'package:newf/core/constants/app_api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/dio_error_handler.dart';
import 'package:newf/core/api_helper/dio_helper.dart';
import 'package:newf/core/api_helper/response_handler.dart';
import 'package:newf/core/base/base_remote_repo.dart';

class BottomNavBarRepo extends BaseRepo {
  final DioHelper dio;
  BottomNavBarRepo(this.dio);
}

