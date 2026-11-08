import '../../features/pictograms/view/pictogram_activity_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/routines/view/feeding_routine_screen.dart';
import '../../features/routines/view/morning_hygiene_screen.dart';
import '../../features/routines/view/routine_selection_screen.dart';
import '../../features/routines/view/morning_hygiene_screen.dart';
import '../../features/emotions/view/emotion_activity_screen.dart';
import '../../features/auth/view/auth_choice_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/child_menu/view/child_menu_screen.dart';
import '../../features/child_menu/view/section_placeholder_screen.dart';
import '../../features/profile/view/avatar_selection_screen.dart';
import '../../features/profile/view/create_profile_screen.dart';
import '../../features/profile/view/edit_profile_screen.dart';
import '../../features/profile/view/profiles_screen.dart';
import '../../features/welcome/view/initial_menu_screen.dart';
import '../../features/welcome/view/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;

      final isLoggedIn = session != null;
      final currentPath = state.uri.path;

      final publicRoutes = {'/', '/auth', '/login', '/register'};

      final isPrivateRoute =
          currentPath == '/home' ||
          currentPath.startsWith('/profile') ||
          currentPath.startsWith('/child');

      // Si no hay sesión y se intenta entrar a una ruta privada.
      if (!isLoggedIn && isPrivateRoute) {
        return '/auth';
      }

      // Si ya existe sesión, no volvemos a login o registro.
      if (isLoggedIn && publicRoutes.contains(currentPath)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthChoiceScreen(),
      ),

      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const InitialMenuScreen(),
      ),

      GoRoute(
        path: '/profiles',
        name: 'profiles',
        builder: (context, state) => const ProfilesScreen(),
      ),

      GoRoute(
        path: '/profile/create',
        name: 'create-profile',
        builder: (context, state) => const CreateProfileScreen(),
      ),

      GoRoute(
        path: '/profile/:id/edit',
        name: 'edit-profile',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return EditProfileScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/menu',
        name: 'child-menu',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return ChildMenuScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/avatar',
        name: 'child-avatar',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return AvatarSelectionScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/pictograms',
        name: 'child-pictograms',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return PictogramActivityScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/emotions',
        name: 'child-emotions',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return EmotionActivityScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/routines',
        name: 'child-routines',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return RoutineSelectionScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/routines/hygiene',
        name: 'child-routine-hygiene',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return MorningHygieneScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/routines/feeding',
        name: 'child-routine-feeding',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return FeedingRoutineScreen(profileId: profileId);
        },
      ),

      GoRoute(
        path: '/child/:id/rewards',
        name: 'child-rewards',
        builder: (context, state) {
          final profileId = state.pathParameters['id']!;

          return SectionPlaceholderScreen(
            profileId: profileId,
            title: 'Mis logros',
            icon: Icons.emoji_events_outlined,
          );
        },
      ),
    ],
  );
}
