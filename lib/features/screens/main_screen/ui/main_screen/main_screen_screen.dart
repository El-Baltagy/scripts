import 'package:newf/core/app/route.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/core/constants/app_locator.dart';
import 'package:newf/features/screens/main_screen/controller/main_screen_cubit.dart';

part 'main_screen_screen_mixin.dart';
part 'widgets/sized_box.dart';
part 'widgets/column_behaviour.dart';
part 'widgets/main_screen_body.dart';

@RoutePage()
class MainScreenPage extends StatefulWidget implements AutoRouteWrapper {
  const MainScreenPage({super.key, required this.args});
  final MainScreenRouteArgs args;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<MainScreenCubit>(
      create: (context) => AppLocator()()(),
      child: this,
    );
  }

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends MainScreenPageBaseState {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(
        Semantics(
          label: 'MainScreenBody',
          child: const MainScreenBody(),
        ),
      ),
    );
  }
}
