import 'package:flutter/material.dart';
import 'package:leam/src/config/routes/app_routes.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Leam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,

    );
  }
}
