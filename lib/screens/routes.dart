import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/screens/error_screen.dart';
import 'package:flutter_gregtext_game/screens/game/profile_selection_screen.dart';
import 'package:flutter_gregtext_game/services/local_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// explore (biomes, ore)
// base (expandable (sizes and multible bases), item/fluid storage (ME??), machines),
// craft
// login not req
// users selections

class AppRouter {
  late final GoRouter router;

  bool _hasProfile = false;
  Future<void> initialize(SharedPreferences prefs) async {
    // Check local storage for saved state
    String? lastProfileId = await LocalStorageService(prefs).getLastProfileId();
    _hasProfile = lastProfileId != null && lastProfileId.isNotEmpty;
    router = GoRouter(
      initialLocation: _getInitialLocation(),
      routes: _buildRoutes(),
      redirect: _redirectLogic,
      errorBuilder: (context, state) => const ErrorScreen(),
      refreshListenable: GoRouterRefreshListenable(),
    );
  }

  String _getInitialLocation() {
    if (_hasProfile) return '/game/explore';
    return '/profile';
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
            builder: (_, _) => const Text("LoginScreen()"),
          ),
          GoRoute(
            path: 'register',
            name: 'auth-register',
            builder: (_, _) => const Text("RegisterScreen()"),
          ),
        ],
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (_, _) => const ProfileSelectionScreen(),
      ),

      ShellRoute(
        builder: (_, _, child) => Text("GameShell(child: child)"),
        routes: [
          GoRoute(
            path: '/game/explore',
            name: 'game-explore',
            builder: (_, _) => const Text("ExploreScreen()"),
            routes: [
              // GoRoute(
              //   path: 'location/:locationId',
              //   name: 'game-location',
              //   builder: (_ , _) {
              //     final locationId = state.pathParameters['locationId']!;
              //     return Text("LocationDetailScreen(locationId: locationId)");
              //   },
              // ),
            ],
          ),
          GoRoute(
            path: '/game/base',
            name: 'game-base',
            builder: (_, _) => const Text("BaseScreen()"),
          ),
          GoRoute(
            path: '/game/craft',
            name: 'game-craft',
            builder: (_, _) => const Text("CraftScreen()"),
          ),
          GoRoute(
            path: '/game/settings',
            name: 'game-settings',
            builder: (_, _) => const Text("SettingsScreen()"),
          ),
          GoRoute(
            path: '/game/more',
            name: 'game-more',
            builder: (_, _) => const Text("MoreScreen()"),
          ),
        ],
      ),
    ];
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    // Allow access to profile screens if no profile exists
    final isProfileScreen = state.matchedLocation.startsWith('/profile');
    final isGameScreen = state.matchedLocation.startsWith('/game');

    // If no profile and trying to access game, go to profile selection
    if (!_hasProfile && isGameScreen) {
      return '/profile';
    }

    // If has profile and on profile screens, go to game
    if (_hasProfile && isProfileScreen) {
      return '/game/explore';
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
