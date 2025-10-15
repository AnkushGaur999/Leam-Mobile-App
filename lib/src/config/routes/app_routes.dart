import 'package:go_router/go_router.dart';
import 'package:leam/src/views/auth/login_screen.dart';
import 'package:leam/src/views/auth/otp_screen.dart';
import 'package:leam/src/views/dashboard_screen.dart';
import 'package:leam/src/views/home_screen.dart';
import 'package:leam/src/views/splash_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String otp = 'otp';
  static const String home = 'home';
  static const String dashboard = 'dashboard';

  static const String _splash = '/';
  static const String _login = '/login';
  static const String _otp = '/otp';
  static const String _home = '/home';
  static const String _dashboard = '/dashboard';

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: splash,
        path: _splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: otp,
        path: _otp,
        builder: (context, state) =>
            OtpScreen(mobileNumber: state.extra! as String),
      ),

      GoRoute(
        name: login,
        path: _login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        name: home,
        path: _home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: dashboard,
        path: _dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
