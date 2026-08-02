import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' ;
 import 'package:newf/features/screens/main_home/ui/main_home/main_home_screen.dart';
part  'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
      AutoRoute(
        page: MainHomeRoute.page,
        // initial: true,
      ),


  ];
}
// class AuthGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final isLoggedIn = false; // check your auth state
//     if (isLoggedIn) {
//       resolver.next(true);
//     } else {
//       router.replace(const AuthRoute());
//     }
//   }
// }
      