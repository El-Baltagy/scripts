import 'package:newf/core/constants/app_typedef.dart';
import 'package:newf/core/constants/app_constant.dart';
import 'package:newf/core/shared/methods/print.dart';
import 'package:newf/core/base/base_local_repo.dart';
import 'package:newf/features/screens/main_screen/data/repo/base_main_screen_repo.dart';
import 'package:newf/features/screens/main_screen/service/base_main_screen_service.dart';

import '../../../../core/base/base_service.dart';
import '../../../../core/shared/methods/no_parameter.dart';
import '../data/model/project_data.dart';

/// Concrete implementation of [BaseMainScreenService].
/// Depends on [BaseMainScreenRepo] (abstraction), not on the remote repo directly.
class MainScreenRemoteService implements BaseMainScreenService {
  MainScreenRemoteService(this._remoteRepo, this._localRepo);

  final BaseMainScreenRepo _remoteRepo;
  final BaseLocalRepo _localRepo;

  @override
  Future<void> getProjectsServ(
    RequestCallbackObserver<PojectsData, NoParameters> requestInfo,
  ) {
    const cacheKey = AppConstant.getProjectsKeyCash;
    return requestInfo.handleRequest(
      fetchFromClient: (token) => _remoteRepo.getProjectsApi(
        requestInfo.parameter,
        cancelToken: token,
      ),
      fetchLocal: () async {
        final tuple = await _localRepo.readData(cacheKey);

        if (tuple?.$1['pr'] == _localRepo.primarySessionId) {
          return PojectsData.fromJson(tuple!.$2);
        }
        return null;
      },
      saveLocal: (old, newData) async {

      },
      clearLocal: () => _localRepo.clearData(cacheKey),
    );
  }
}
