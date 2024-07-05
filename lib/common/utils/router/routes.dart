import 'package:go_router/go_router.dart';
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart';

/// The route configuration.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
  ],
);
