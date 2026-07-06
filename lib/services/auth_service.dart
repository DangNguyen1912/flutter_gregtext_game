import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user/user.dart' as game;

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  AuthService() {
    _init();
  }

  void _init() {
    firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      var userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final gameUser = game.User(
        userId: userCredential.user!.uid,
        userName: username,
        createDate: DateTime.now(),
        playedTime: Duration.zero,
        gameStage: 0,
        inventory: null,
        exploredArea: [],
      );

      await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(gameUser.toMap());

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await firebaseAuth.currentUser!.reauthenticateWithCredential(credential);

    // Delete Firestore data
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .delete();

    await firebaseAuth.currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
    await firebaseAuth.currentUser!.updatePassword(newPassword);
  }
}
