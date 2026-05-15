import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/core/constants/app_locator.dart';
import 'package:newf/features/screens/bottom_nav_bar/controller/bottom_nav_bar_cubit.dart';
import 'package:newf/features/screens/bottom_nav_bar/controller/bottom_nav_bar_state.dart';





@RoutePage()
class BottomNavBarPage extends StatefulWidget implements AutoRouteWrapper{
  const BottomNavBarPage({super.key});
  // 2. Implement the wrappedRoute method
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<BottomNavBarCubit>(
      // Use your singleton to get the Cubit instance
      create: (context) =>BottomNavBarCubit(AppLocator()()()),
      child: this, // 'this' refers to the AuthPage itself
    );
  }
  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends BottomNavBarPageBaseState {

  @override
  Widget build(BuildContext context) {
     return BlocListener<BottomNavBarCubit, BottomNavBarState>(
      listener: (context, state) {
        // TODO: implement listener}
      },
      child: Scaffold(

      ),
    );
    
  }
}


abstract class  BottomNavBarPageBaseState extends State<BottomNavBarPage> {
  final BottomNavBarCubit argData=BottomNavBarCubit.get();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
