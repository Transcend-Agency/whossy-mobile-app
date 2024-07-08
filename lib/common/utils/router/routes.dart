import 'package:go_router/go_router.dart';
import 'package:whossy_mobile_app/feature/auth/login_screen.dart';
import 'package:whossy_mobile_app/feature/auth/reset_pass_screen.dart';
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart';

/// The route configuration.
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      routes: [authRoute],
    ),
  ],
);

final authRoute = GoRoute(
  path: 'auth',
  builder: (context, state) => const LoginScreen(),
  routes: [
    GoRoute(
      path: "reset-password",
      builder: (context, state) => const ResetPasswordScreen(),
    )
  ],
);
