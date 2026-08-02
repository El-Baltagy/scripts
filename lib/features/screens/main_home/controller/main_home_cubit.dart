    import 'package:newf/core/shared/methods/print.dart';
    import 'package:newf/core/constants/app_constant.dart';
 import 'package:newf/core/base/base_state.dart';
 import 'package:newf/core/base/base_service.dart';   
import 'package:newf/core/base/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/main.dart';
import 'package:newf/features/screens/main_home/service/main_home_service.dart';
part 'main_home_state.dart';

class MainHomeCubit extends BaseCubit<MainHomeState> {
   MainHomeCubit(this._service) : super(MainHomeLoaded()) ;
  final MainHomeService _service;
  
     static MainHomeCubit get({BuildContext? context,bool listen=false}) =>
      BlocProvider.of(context??navigatorKey.currentContext!,listen: listen);
  
    // Always holds the latest combined state — used by copyWith
   MainHomeLoaded get _current => state is MainHomeLoaded
       ? state as MainHomeLoaded
       : MainHomeLoaded();
       
    Future<void> init() async {
     // TODO: implement init

   }
  
}
