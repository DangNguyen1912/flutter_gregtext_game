import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/screens/auth/sign_in_screen.dart';
import 'package:flutter_gregtext_game/screens/error_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// explore (biomes, ore)
// base (expandable (sizes and multible bases), item/fluid storage (ME??), machines),
// craft
// login not req
// users selections

class AppRouter {
  // Singleton pattern
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  late final GoRouter router;

  static bool _isAuthenticated = false;

  Future<void> initialize(SharedPreferences prefs, bool isAuthenticated) async {
    _isAuthenticated = isAuthenticated;

    router = GoRouter(
      initialLocation: _getInitialLocation(),
      routes: _buildRoutes(),
      redirect: _redirectLogic,
      errorBuilder: (context, state) => const ErrorScreen(),
      refreshListenable: GoRouterRefreshListenable(),
    );
  }

  String _getInitialLocation() {
    if (!_isAuthenticated) return '/auth/login';
    return '/explore';
  }

  List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: '/auth',
        name: 'auth',
        redirect: (_, _) => '/auth/login',
        routes: [
          GoRoute(
            path: 'login',
            name: 'auth-login',
            builder: (_, _) => const SignInScreen(),
          ),
          GoRoute(
            path: 'register',
            name: 'auth-register',
            builder: (_, _) => const Text("RegisterScreen()"),
          ),
        ],
      ),

      ShellRoute(
        builder: (_, _, child) => Text("GameShell(child: child)"),
        routes: [
          GoRoute(
            path: '/explore',
            name: 'game-explore',
            builder: (_, _) => const Text("ExploreScreen()"),
          ),
          GoRoute(
            path: '/base',
            name: 'game-base',
            builder: (_, _) => const Text("BaseScreen()"),
          ),
          GoRoute(
            path: '/craft',
            name: 'game-craft',
            builder: (_, _) => const Text("CraftScreen()"),
          ),
          GoRoute(
            path: '/settings',
            name: 'game-settings',
            builder: (_, _) => const Text("SettingsScreen()"),
          ),
          GoRoute(
            path: '/more',
            name: 'game-more',
            builder: (_, _) => const Text("MoreScreen()"),
          ),
        ],
      ),
    ];
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    final isAuthScreen = state.matchedLocation.startsWith('/auth');

    if (!_isAuthenticated && !isAuthScreen) {
      return '/auth/login';
    }

    return null;
  }
}

class GoRouterRefreshListenable extends ChangeNotifier {
  static final GoRouterRefreshListenable _instance =
      GoRouterRefreshListenable._internal();
  factory GoRouterRefreshListenable() => _instance;
  GoRouterRefreshListenable._internal();

  void refresh() {
    notifyListeners();
  }
}
