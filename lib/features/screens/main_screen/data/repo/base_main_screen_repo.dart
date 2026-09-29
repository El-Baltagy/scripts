import 'package:newf/core/api_helper/dio_error_handler.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:newf/core/base/base_remote_repo.dart';

import '../../../../../core/shared/methods/no_parameter.dart';
import '../model/project_data.dart';

/// Abstract contract for the main_screen data layer.
/// High-level modules (services) depend on this, not on concrete implementations.
abstract class BaseMainScreenRepo extends BaseRepo {
  // TODO: declare repo method signatures here

  /// Abstract contract — implemented by [MainScreenRemoteRepo].
  Future<Either<Failure, PojectsData>> getProjectsApi(
    NoParameters? parameter, {
    CancelToken? cancelToken,
  });
}
