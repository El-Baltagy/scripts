import 'package:newf/core/base/base_service.dart';
import 'package:newf/core/base/base_local_repo.dart';
import 'package:newf/features/screens/bottom_nav_bar/data/repo/remote/bottom_nav_bar_repo.dart';

class BottomNavBarService extends BaseService {
  BottomNavBarService(this._remoteRepo, this._localRepo);
  
  final BottomNavBarRepo _remoteRepo;
  final BaseLocalRepo _localRepo;
}
