import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../app_constants.dart';
import 'firestore_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  FirestoreService? _firestoreService;

  User? get user => _user;
  FirestoreService? get firestoreService => _firestoreService;

  /// Expose auth for advanced operations (e.g. password reset)
  FirebaseAuth get firebaseAuth => _auth;

  bool get isEmailVerified => _user?.emailVerified ?? false;
  
  bool get isAdmin => _user?.email == AppConstants.adminEmail;

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await user.reload(); // Refresh user state (e.g. emailVerified)
        _user = _auth.currentUser;
        _firestoreService = FirestoreService(uid: user.uid);
      } else {
        _firestoreService = null;
      }
      notifyListeners();
    });
  }

  Future<void> reloadUser() async {
    await _user?.reload();
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> sendEmailVerification() async {
    await _user?.sendEmailVerification();
  }


  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      if (kDebugMode) print('Error signing in anonymously: $e');
      rethrow;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('Login error [${e.code}]: ${e.message}');
      throw Exception(e.code);
    } catch (e) {
      if (kDebugMode) print('Unexpected login error: $e');
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password,
      {String? displayName}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (displayName != null && displayName.isNotEmpty) {
        await cred.user?.updateDisplayName(displayName);
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('Signup error [${e.code}]: ${e.message}');
      throw Exception(e.code);
    } catch (e) {
      if (kDebugMode) print('Unexpected signup error: $e');
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('Reset error [${e.code}]: ${e.message}');
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Error signing out: $e');
      rethrow;
    }
  }
}
