import 'package:newf/core/api_helper/cancel/cancel_manager.dart';
    import 'package:newf/core/shared/methods/print.dart';
    import 'package:newf/core/constants/app_constant.dart';
 import 'package:newf/core/base/base_state.dart';
 import 'package:newf/core/base/base_service.dart';   
import 'package:newf/core/base/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/main.dart';
import 'package:newf/features/screens/main_screen/service/base_main_screen_service.dart';

import '../../../../core/shared/methods/no_parameter.dart';
import '../data/model/project_data.dart';
part 'main_screen_state.dart';

class MainScreenCubit extends BaseCubit<MainScreenState> {
   MainScreenCubit(this._service) : super(MainScreenLoaded()) ;

  /// Depends on the abstraction [BaseMainScreenService], not on a concrete implementation.
  final BaseMainScreenService _service;
  
     static MainScreenCubit get({BuildContext? context,bool listen=false}) =>
      BlocProvider.of(context??navigatorKey.currentContext!,listen: listen);
  
    // Always holds the latest combined state — used by copyWith
   MainScreenLoaded get _current => state is MainScreenLoaded
       ? state as MainScreenLoaded
       : MainScreenLoaded();
       
      int get getProjectsKeyCode => AppConstant.getProjectsKeyCode;

  Future<void> init() async {
     // TODO: implement init

   }
  

  Future<void> getProjectsFunc(BaseRequestBackType baseRequestBackType,{NoParameters? parameter}) async {
    await CancelManager.runCancelableFun(getProjectsKeyCode, (token) async {
      await _service.getProjectsServ(
        RequestCallbackObserver<PojectsData, NoParameters>(
          baseRequestBackType: baseRequestBackType ,
          parameter: parameter,
          cancelToken: token,
          onLoadCallback: () => safeEmit(_current.copyWith(getProjectsState: Loading())),
          onRightCallback: (data) => safeEmit(_current.copyWith(getProjectsState: Success(data))),
          onLeftCallback: (failure) => safeEmit(_current.copyWith(getProjectsState: ErrorState(failure))),
        ),
      );
    });
  }
  @override
  Future<void> close() {
    // add every key in file
    CancelManager.cancel(getProjectsKeyCode);
    return super.close();
  }
}
