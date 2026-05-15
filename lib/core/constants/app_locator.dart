


import 'package:newf/features/screens/bottom_nav_bar/data/repo/remote/bottom_nav_bar_repo.dart';
import 'package:newf/features/screens/bottom_nav_bar/service/bottom_nav_bar_service.dart';
import 'package:newf/features/screens/bottom_nav_bar/controller/bottom_nav_bar_cubit.dart';
import 'package:get_it/get_it.dart';
import '../api_helper/dio_helper.dart';
import '../base/base_local_repo.dart';





class AppLocator {
  AppLocator._();
  static final AppLocator _instance = AppLocator._();
  factory AppLocator() => _instance;

  final _sl = GetIt.instance;
  GetIt call() => _sl;

  void init(){
    ///..................bottom_nav_bar.................///
    _sl.registerLazySingleton(() => BottomNavBarRepo(_sl()));
    _sl.registerLazySingleton(() => BottomNavBarService(_sl(), _sl()));
    _sl.registerFactory(() => BottomNavBarCubit(_sl()));



    // ── Global Services ──────────────────────────────────────────────────────
    _sl.registerLazySingleton<BaseLocalRepo>(() => BaseLocalRepo());
    _sl.registerLazySingleton<DioHelper>(() => DioHelper()..call());

  }
}