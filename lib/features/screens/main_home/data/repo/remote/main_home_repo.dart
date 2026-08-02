import 'package:newf/core/shared/methods/print.dart';        
import 'package:newf/core/constants/app_api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/caller_tag.dart';
import 'package:newf/core/api_helper/dio_error_handler.dart';
import 'package:newf/core/api_helper/dio_helper.dart';
import 'package:newf/core/api_helper/response_handler.dart';
import 'package:newf/core/base/base_remote_repo.dart';

class MainHomeRepo extends BaseRepo {
  final DioHelper dio;
  MainHomeRepo(this.dio);
}

