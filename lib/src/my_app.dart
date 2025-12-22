import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/config/di/service_locator.dart';
import 'package:leam/src/core/config/routes/app_routes.dart';
import 'package:leam/src/core/constants/app_colors.dart';
import 'package:leam/src/repositories/auth_repository.dart';
import 'package:leam/src/repositories/chat_repository.dart';
import 'package:leam/src/repositories/profile_repository.dart';
import 'package:leam/src/repositories/user_repository.dart';
import 'package:leam/src/viewmodels/auth/auth_view_model.dart';
import 'package:leam/src/viewmodels/chat/chat_list/chat_list_view_model.dart';
import 'package:leam/src/viewmodels/profile/profile_view_model.dart';
import 'package:leam/src/viewmodels/user/user_view_model.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => getIt<AuthRepository>()),
        RepositoryProvider(create: (context) => getIt<ChatRepository>()),
        RepositoryProvider(create: (context) => getIt<UserRepository>()),
        RepositoryProvider(create: (context) => getIt<ProfileRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<AuthViewModel>()),
          BlocProvider(create: (context) => getIt<ProfileViewModel>()),
          BlocProvider(create: (context) => getIt<ChatListViewModel>()),
          BlocProvider(create: (context) => getIt<UserViewModel>()),
        ],
        child: MaterialApp.router(
          title: 'Leam',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
            primaryColor: AppColors.primaryColor,
            primarySwatch: AppColors.primarySwatch,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primaryColor,
              centerTitle: false,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),

          routerConfig: AppRoutes.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
