import 'package:newf/core/app/route.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/core/constants/app_locator.dart';
import 'package:newf/features/screens/main_home/controller/main_home_cubit.dart';
 
part 'main_home_screen_mixin.dart';

@RoutePage()
class MainHomePage extends StatefulWidget implements AutoRouteWrapper {
  const MainHomePage({super.key, required this.args});
  final MainHomeRouteArgs args;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<MainHomeCubit>(
      create: (context) =>  AppLocator()()() ,
      child: this,
    );
  }

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends MainHomePageBaseState {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainHomeCubit, MainHomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(

      ),
    );
  }
}
