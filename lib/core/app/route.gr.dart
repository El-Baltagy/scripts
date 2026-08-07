// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    MainScreenRoute.name: (routeData) {
      final args = routeData.argsAs<MainScreenRouteArgs>(orElse: () =>   MainScreenRouteArgs.noArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: MainScreenPage(
           args: args ,
        )),
      );
    },
 
  };
}

/// generated route for
/// [MainScreenPage]
class MainScreenRoute extends PageRouteInfo<MainScreenRouteArgs> {
  MainScreenRoute({
   required MainScreenRouteArgs args  ,
    List<PageRouteInfo>? children,
  }) : super(
    MainScreenRoute.name,
    args: args,
    initialChildren: children,
  );

  static const String name = 'MainScreenRoute';

  static const PageInfo<MainScreenRouteArgs> page =
  PageInfo<MainScreenRouteArgs>(name);
}
class MainScreenRouteArgs {
  const MainScreenRouteArgs( );
   static MainScreenRouteArgs noArgs()=>MainScreenRouteArgs();
}
