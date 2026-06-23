// import 'screens/auth/onboarding_screen.dart';
// import 'screens/home/help_screen.dart';
// import 'screens/home/me_screen.dart';
// import 'screens/home/notes_screen.dart';
// import 'screens/home/ocr_screen.dart';
// import 'screens/splash_screen.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  bool _isSplashing = true;

  @override
  void initState() {
    super.initState();
    // splash screen for 1 second then move on
    splashing();
  }

  void splashing() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isSplashing = false;
      });
    });
  }

  // List<Widget> home = [NotesScreen(), OcrScreen(), HelpScreen(), MeScreen()];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, auth, child) {
        return StreamBuilder<User?>(
          stream: auth.authStateChanges,
          builder: (context, snapshot) {
            Widget screen;
            if (snapshot.connectionState == ConnectionState.waiting ||
                _isSplashing) {
              screen = Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // explore (biomes, ore)
              // base (expandable (sizes and multible bases), item/fluid storage (ME??), machines),
              // craft
              screen = Text("home");
            } else {
              // login not req
              // users selections
              screen = Text("login");
            }
            return screen;
          },
        );
      },
    );
  }
}
