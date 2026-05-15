import 'package:auto_route/auto_route.dart';
 import 'package:newf/features/screens/bottom_nav_bar/ui/bottom_nav_bar_screen.dart';
part  'route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter() : super();

  @override
  List<AutoRoute> get routes => [
      AutoRoute(
        page: BottomNavBarRoute.page,
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
      