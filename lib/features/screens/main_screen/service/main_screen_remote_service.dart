import 'package:newf/core/shared/methods/print.dart';
import 'package:newf/core/base/base_local_repo.dart';
import 'package:newf/features/screens/main_screen/data/repo/base_main_screen_repo.dart';
import 'package:newf/features/screens/main_screen/service/base_main_screen_service.dart';

/// Concrete implementation of [BaseMainScreenService].
/// Depends on [BaseMainScreenRepo] (abstraction), not on the remote repo directly.
class MainScreenRemoteService implements BaseMainScreenService {
  MainScreenRemoteService(this._remoteRepo, this._localRepo);

  final BaseMainScreenRepo _remoteRepo;
  final BaseLocalRepo _localRepo;
}
