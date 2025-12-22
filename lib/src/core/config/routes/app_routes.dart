import 'package:go_router/go_router.dart';
import 'package:leam/src/views/auth/login_screen.dart';
import 'package:leam/src/views/auth/otp_screen.dart';
import 'package:leam/src/views/auth/sign_up_screen.dart';
import 'package:leam/src/views/chat/chat_screen.dart';
import 'package:leam/src/views/dashboard/dashboard_screen.dart';
import 'package:leam/src/views/profile_screen.dart';
import 'package:leam/src/views/splash_screen.dart';

class AppRoutes {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signUp = 'sign-up';
  static const String otp = 'otp';
  static const String dashboard = 'dashboard';
  static const String chat = 'chat';
  static const String profile = 'profile';

  static const String _splash = '/';
  static const String _login = '/login';
  static const String _signUp = '/sign-up';
  static const String _otp = '/otp';
  static const String _dashboard = '/dashboard';
  static const String _chat = '/chat/:chatRoomId/:userId';
  static const String _profile = '/profile';

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
        name: signUp,
        path: _signUp,
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        name: dashboard,
        path: _dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),

      GoRoute(
        name: chat,
        path: _chat,
        builder: (context, state) {
          final roomId = state.pathParameters["chatRoomId"]!;
          final userId = state.pathParameters["userId"]!;
          return ChatScreen(chatRoomId: roomId, userId: userId);
        },
      ),

      GoRoute(
        name: profile,
        path: _profile,
        builder: (context, state) => ProfileScreen(),
      ),
    ],
  );
}
