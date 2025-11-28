import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leam/src/config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    final user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 1));

    if (mounted && user != null) {
      context.goNamed(AppRoutes.dashboard);
    } else {
      if (mounted) context.goNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/app_logo.png",
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
