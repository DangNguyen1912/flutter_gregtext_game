import 'package:flutter/material.dart';
import 'package:flutter_gregtext_game/screens/error_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'user',
      builder: (context, state) => const Text(""),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const Text(""),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);

// explore (biomes, ore)
// base (expandable (sizes and multible bases), item/fluid storage (ME??), machines),
// craft
// login not req
// users selections
