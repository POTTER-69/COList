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
import 'package:colist_proj/screens/invite_screen/invite_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splashScreen,

    redirect: (context, state) {
      final String location = state.uri.toString();

      if (location.startsWith('https://colist.app')) {
        return location.replaceFirst('https://colist.app', '');
      }
      return null;
    },

    routes: [
      GoRoute(path: AppRoutes.splashScreen, name: AppRoutes.splashScreen, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.onBoardingScreen, name: AppRoutes.onBoardingScreen, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.welcomeScreen, name: AppRoutes.welcomeScreen, builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.loginScreen, name: AppRoutes.loginScreen, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.registerScreen, name: AppRoutes.registerScreen, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: AppRoutes.createNewPasswordScreen, name: AppRoutes.createNewPasswordScreen, builder: (context, state) => const CreateNewPasswordScreen()),
      GoRoute(path: AppRoutes.passwordChangedScreen, name: AppRoutes.passwordChangedScreen, builder: (context, state) => const PasswordChangedScreen()),
      GoRoute(path: AppRoutes.homeScreen, name: AppRoutes.homeScreen, builder: (context, state) => const HomeScreen()),
      GoRoute(path: AppRoutes.forgetPasswordScreen, name: AppRoutes.forgetPasswordScreen, builder: (context, state) => const ForgetPasswordScreen()),
      GoRoute(path: AppRoutes.mainScreen, name: AppRoutes.mainScreen, builder: (context, state) => const MainScreen()),

      GoRoute(
        path: AppRoutes.listDetailsScreen,
        name: AppRoutes.listDetailsScreen,
        builder: (context, state) {
          String listId = '';
          String listName = '';

          if (state.extra != null && state.extra is Map<String, dynamic>) {
            final args = state.extra as Map<String, dynamic>;
            listId = args['id'] ?? '';
            listName = args['name'] ?? '';
          }
          else {
            listId = state.uri.queryParameters['id'] ?? '';
            listName = state.uri.queryParameters['name'] ?? '';
          }

          return ListDetailsScreen(
            listId: listId,
            listName: listName,
          );
        },
      ),

      GoRoute(path: AppRoutes.notificationScreen, name: AppRoutes.notificationScreen, builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.archivedScreen, name: AppRoutes.archivedScreen, builder: (context, state) => const ArchivedScreen()),
      GoRoute(path: AppRoutes.settingsScreen, name: AppRoutes.settingsScreen, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: AppRoutes.addToListScreen, name: AppRoutes.addToListScreen, builder: (context, state) => const AddToList()),

      GoRoute(
        path: AppRoutes.inviteCollaboratorsScreen,
        name: AppRoutes.inviteCollaboratorsScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {'id': '', 'name': ''};
          return InviteCollaboratorsScreen(
            listId: args['id'],
            listName: args['name'],
          );
        },
      ),
    ],
  );
}