import '../../features/profile/view/create_profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/view/auth_choice_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import '../../features/welcome/view/initial_menu_screen.dart';
import '../../features/welcome/view/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    redirect: (context, state) {
      final session =
          Supabase.instance.client.auth.currentSession;

      final isLoggedIn = session != null;
      final currentPath = state.uri.path;

      final publicRoutes = {
        '/',
        '/auth',
        '/login',
        '/register',
      };

      // Usuario no autenticado intentando entrar al área privada.
      final isPrivateRoute =
        currentPath == '/home' ||
        currentPath.startsWith('/profile');
      
      if (!isLoggedIn && isPrivateRoute) {
        return '/auth';
        }

      // Usuario autenticado intentando volver a las pantallas
      // de autenticación.
      if (isLoggedIn && publicRoutes.contains(currentPath)) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) =>
            const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) =>
            const AuthChoiceScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) =>
            const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) =>
            const InitialMenuScreen(),
      ),
      GoRoute(
        path: '/profile/create',
        name: 'create-profile',
        builder: (context, state) =>
            const CreateProfileScreen(),
            ),
    ],
  );
}