import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/screens/auth/forgot_password_screen.dart';
import 'package:flutter_gregtext_game/screens/auth/register_screen.dart';
import 'package:flutter_gregtext_game/screens/auth/sign_in_screen.dart';
import 'package:flutter_gregtext_game/screens/game/base_screen.dart';
import 'package:flutter_gregtext_game/screens/game/craft_screen.dart';
import 'package:flutter_gregtext_game/screens/game/explore_screen.dart';
import 'package:flutter_gregtext_game/screens/game/inventory_screen.dart';
import 'package:flutter_gregtext_game/screens/game/shell_nav_bar.dart';
import 'package:flutter_gregtext_game/screens/settings_screen.dart';
import 'package:flutter_gregtext_game/services/auth_service.dart';
import 'package:flutter_gregtext_game/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// explore (biomes, ore)
// base (expandable (sizes and multible bases), item/fluid storage (ME??), machines),
// craft

class AppRouter {
  static GoRouter router(AuthService authService) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isAuthenticated = authService.isAuthenticated;
        final isInitialized = authService.isInitialized;
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Wait for auth to initialize
        if (!isInitialized) return null;

        if (!isAuthenticated && !isAuthRoute) return '/login';

        if (isAuthenticated && isAuthRoute) return '/explore';

        // If authenticated and at root, go to explore
        if (isAuthenticated && state.matchedLocation == '/') return '/explore';

        // If not authenticated at root, go to login
        if (!isAuthenticated && state.matchedLocation == '/') return '/login';

        return null;
      },
      routes: [
        // Auth routes
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (_, _) => const SignInScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (_, _) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: 'forgot-password',
          builder: (_, _) => const ForgotPasswordScreen(),
        ),
        // Main game routes with bottom nav
        StatefulShellRoute.indexedStack(
          builder: (_, _, navigationShell) =>
              ShellNavBar(navigationShell: navigationShell),
          branches: [
            _statefulShellBranch('explore', const ExploreScreen()),
            _statefulShellBranch('base', const BaseScreen()),
            _statefulShellBranch('inventory', const InventoryScreen()),
            _statefulShellBranch('craft', const CraftScreen()),
            _statefulShellBranch('settings', const SettingsScreen()),
          ],
        ),
      ],
    );
  }

  static StatefulShellBranch _statefulShellBranch(String path, Widget child) {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/$path',
          name: path,
          pageBuilder: (context, _) {
            final authService = Provider.of<AuthService>(
              context,
              listen: false,
            );
            return MaterialPage(
              child: Provider<DatabaseService>(
                create: (_) => DatabaseService(userId: authService.user!.uid),
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }
}
