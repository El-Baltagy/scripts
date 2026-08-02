import 'package:newf/core/shared/methods/print.dart';    
import 'package:newf/core/base/base_service.dart';
import 'package:newf/core/base/base_local_repo.dart';
import 'package:newf/features/screens/main_home/data/repo/remote/main_home_repo.dart';

class MainHomeService extends BaseService {
  MainHomeService(this._remoteRepo, this._localRepo);
  
  final MainHomeRepo _remoteRepo;
  final BaseLocalRepo _localRepo;
}
