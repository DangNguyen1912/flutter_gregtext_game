import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      // actions: [
      //   AuthStateChangeAction<UserCreated>((context, state) {}),
      //   AuthStateChangeAction<SignedIn>((context, state) {}),
      // ],
    );
  }
}
