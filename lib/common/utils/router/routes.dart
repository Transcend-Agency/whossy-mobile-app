import 'package:go_router/go_router.dart';
import 'package:whossy_mobile_app/feature/auth/login_screen.dart';
import 'package:whossy_mobile_app/feature/auth/reset_pass_screen.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/signup.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/signup_details.dart';
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart';

/// The route configuration.
final router = GoRouter(
  initialLocation: '/auth-signup/signup-details',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const SplashScreen(),
      routes: [loginRoute, signUpRoute],
    ),
  ],
);

final loginRoute = GoRoute(
  path: 'auth-login',
  name: 'login',
  builder: (context, state) => const LoginScreen(),
  routes: [
    GoRoute(
      name: 'reset-1',
      path: "reset-password",
      builder: (context, state) => const ResetPasswordScreen(),
    )
  ],
);

final signUpRoute = GoRoute(
  path: 'auth-signup',
  name: 'signup',
  builder: (context, state) => const SignUpScreen(),
  routes: [
    GoRoute(
      name: 'signup-det',
      path: "signup-details",
      builder: (context, state) => const SignUpDetailsScreen(),
    )
  ],
);
