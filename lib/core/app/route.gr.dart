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
    MainHomeRoute.name: (routeData) {
      final args = routeData.argsAs<MainHomeRouteArgs>(orElse: () =>   MainHomeRouteArgs.noArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: MainHomePage(
           args: args ,
        )),
      );
    },

  };
}
/// generated route for
/// [MainHomePage]
class MainHomeRoute extends PageRouteInfo<MainHomeRouteArgs> {
  MainHomeRoute({
   required MainHomeRouteArgs args  ,
    List<PageRouteInfo>? children,
  }) : super(
    MainHomeRoute.name,
    args: args,
    initialChildren: children,
  );

  static const String name = 'MainHomeRoute';

  static const PageInfo<MainHomeRouteArgs> page =
  PageInfo<MainHomeRouteArgs>(name);
}
class MainHomeRouteArgs {
  const MainHomeRouteArgs( );
   static MainHomeRouteArgs noArgs()=>MainHomeRouteArgs();
}
