import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/authentication_screens/createNewPasswordScreen.dart';
import '../screens/authentication_screens/forget_password_screen.dart';
import '../screens/authentication_screens/login_screen.dart';
import '../screens/authentication_screens/password_changed_screen.dart';
import '../screens/authentication_screens/register_screen.dart';
import '../screens/authentication_screens/welcome_screen.dart';
import '../screens/home_screen.dart';
import '../screens/list_details_screen/list_details_screen.dart';
import '../screens/main_screen.dart';
import '../screens/on_boarding/onboarding_screen.dart';
import '../screens/splash_screen.dart';
import 'app_routs.dart';
import 'package:colist_proj/screens/notifications_Screen/notifications_screen.dart';
import 'package:colist_proj/screens/archived_screen/archived_screen.dart';
import 'package:colist_proj/screens/settings_screen/settings_screen.dart';
import 'package:colist_proj/screens/add_to_list/add_to_list.dart';


class RouterGenerationConfig {
  static GoRouter goRouter =
      GoRouter(initialLocation: AppRoutes.splashScreen, routes: [
    GoRoute(
        path: AppRoutes.splashScreen,
        name: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen()),
    GoRoute(
        path: AppRoutes.onBoardingScreen,
        name: AppRoutes.onBoardingScreen,
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(
      name: AppRoutes.welcomeScreen,
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      name: AppRoutes.loginScreen,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.registerScreen,
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: AppRoutes.createNewPasswordScreen,
      path: '/createNewPassword',
      builder: (context, state) => const CreateNewPasswordScreen(),
    ),
    GoRoute(
      name: AppRoutes.passwordChangedScreen,
      path: '/passwordChanged',
      builder: (context, state) => const PasswordChangedScreen(),
    ),
    GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen()),
    GoRoute(
      name: AppRoutes.forgetPasswordScreen,
      path: '/forgetPasswordScreen',
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        builder: (context, state) => const MainScreen()),
        GoRoute(
          path: AppRoutes.ListDetailsScreen,
          builder: (context, state) {
            final args = state.extra as Map<String, dynamic>;

            return ListDetailsScreen(
              listId: args['id'],
              listName: args['name'],
            );
          },
        ),
        GoRoute(
          path: AppRoutes.notificationScreen,
          name: AppRoutes.notificationScreen,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppRoutes.archivedScreen,
          name: AppRoutes.archivedScreen,
          builder: (context, state) => const ArchivedScreen(),
        ),
        GoRoute(
          path: AppRoutes.settingsScreen,
          name: AppRoutes.settingsScreen,
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.addToListScreen,
          name: AppRoutes.addToListScreen,
          builder: (context, state) => const AddToList(),
        ),
      ]);
}

