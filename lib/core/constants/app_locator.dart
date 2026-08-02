


import 'package:newf/features/screens/main_home/data/repo/remote/main_home_repo.dart';
import 'package:newf/features/screens/main_home/service/main_home_service.dart';
import 'package:newf/features/screens/main_home/controller/main_home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:newf/core/api_helper/dio_helper.dart';
import 'package:newf/core/base/base_local_repo.dart';
import 'package:newf/core/theming/theme_cubit.dart';

class AppLocator {
  factory AppLocator() => _instance;

  AppLocator._();

  static final AppLocator _instance = AppLocator._();

  final _sl = GetIt.instance;

  GetIt call() => _sl;

  void init(){
    ///..................main_home.................///
    _sl.registerLazySingleton(() => MainHomeRepo(_sl()));
    _sl.registerLazySingleton(() => MainHomeService(_sl(), _sl()));
    _sl.registerFactory(() => MainHomeCubit(_sl()));



    // ── Global Services ──────────────────────────────────────────────────────
    _sl.registerLazySingleton<BaseLocalRepo>(
      () => BaseLocalRepo(
        primarySessionId: DateTime.now().millisecondsSinceEpoch.toString(),
        secondarySessionId:( DateTime.now().millisecondsSinceEpoch+1111).toString(),
       ),
    );
    _sl.registerLazySingleton<DioHelper>(() => DioHelper.instance);
    _sl.registerLazySingleton<ThemeCubit>(ThemeCubit.new);
  }
}
