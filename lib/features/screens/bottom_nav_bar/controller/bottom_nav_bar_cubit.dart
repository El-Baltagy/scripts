    import 'package:newf/core/constants/app_constant.dart';
 import 'package:newf/core/base/base_state.dart';
 import 'package:newf/core/base/base_service.dart';   
import 'package:newf/core/base/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/main.dart';
import 'bottom_nav_bar_state.dart';
import 'package:newf/features/screens/bottom_nav_bar/service/bottom_nav_bar_service.dart';


class BottomNavBarCubit extends BaseCubit<BottomNavBarState> {
   BottomNavBarCubit(this._service) : super(BottomNavBarInitial()) ;
  final BottomNavBarService _service;
  
     static BottomNavBarCubit get({BuildContext? context,bool listen=false}) =>
      BlocProvider.of(context??navigatorKey.currentContext!,listen: listen);
  
  @override
  init() {
    // TODO: implement init
   
  }
  
}
