import 'package:newf/core/constants/app_constant.dart';
import 'package:newf/core/shared/methods/print.dart';
import 'package:newf/core/constants/app_api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/caller_tag.dart';
import 'package:newf/core/api_helper/dio_error_handler.dart';
import 'package:newf/core/api_helper/dio_helper.dart';
import 'package:newf/core/api_helper/response_handler.dart';
import 'package:newf/features/screens/main_screen/data/repo/base_main_screen_repo.dart';

import '../../../../../core/shared/methods/no_parameter.dart';
import '../model/project_data.dart';

/// Concrete remote implementation of [BaseMainScreenRepo].
class MainScreenRemoteRepo implements BaseMainScreenRepo {
  final DioHelper dio;
  MainScreenRemoteRepo(this.dio);

  @override
  Future<Either<Failure, PojectsData>> getProjectsApi(
    NoParameters? parameter, {
    CancelToken? cancelToken,
  }) async {
    return handleResponse(
      onCallData: dio.getData(
        uri: EndPoints.getProjects,
        cancelToken: cancelToken,
        caller: callerTag(),
      ),
      asObject: PojectsData.fromJson,
    );
  }
}
