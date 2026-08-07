import 'package:newf/core/shared/methods/print.dart';
import 'package:newf/core/constants/app_api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/caller_tag.dart';
import 'package:newf/core/api_helper/dio_error_handler.dart';
import 'package:newf/core/api_helper/dio_helper.dart';
import 'package:newf/core/api_helper/response_handler.dart';
import 'package:newf/features/screens/main_screen/data/repo/base_main_screen_repo.dart';

/// Concrete remote implementation of [BaseMainScreenRepo].
class MainScreenRemoteRepo implements BaseMainScreenRepo {
  final DioHelper dio;
  MainScreenRemoteRepo(this.dio);
}
