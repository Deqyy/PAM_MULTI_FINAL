import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signUp({
  required String name,
  required String email,
  required String password
  });

  Future<void> signIn({
  required String email,
  required String password
  });

  Future<void> signOut();

  Future<String?> getCurrentUserDisplayName();

  Future<UserCredential> handleGoogleSignIn();
}