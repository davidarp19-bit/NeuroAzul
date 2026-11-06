import '../../features/auth/view/login_screen.dart';
import '../../features/auth/view/register_screen.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/view/auth_choice_screen.dart';
import '../../features/welcome/view/initial_menu_screen.dart';
import '../../features/welcome/view/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
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
    ],
  );
}