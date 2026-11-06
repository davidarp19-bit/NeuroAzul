import 'package:go_router/go_router.dart';

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
        path: '/home',
        name: 'home',
        builder: (context, state) => const InitialMenuScreen(),
      ),
    ],
  );
}