import 'package:app_resep_makanan/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  Future<void> signUp({
    required String name,
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) => value.user?.updateDisplayName(name));

      FirebaseDatabase.instance.ref().child('users').child(name).set({"nama": name});

      // await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      String? message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      if (message != null && message.isNotEmpty) {
        throw FirebaseAuthException(code: e.code, message: message);
      }
    }
    catch (e) {
        // Catch any other errors
    }
  }

  Future<void> signIn({
    // required BuildContext context,
    required String email,
    required String password
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      // await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacementNamed(
      //   context, '/home');

    } on FirebaseAuthException catch (e) {
      String? message = '';
      message = e.code;
      if (e.code == 'user-not-found') {
        message = 'no user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = "Wrong password provided for that user";
      }
      if (message != null && message.isNotEmpty) {
        throw FirebaseAuthException(code: e.code, message: message);
      }
    } catch (e) {
      // Catch any other errors
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    // Navigator.pushReplacementNamed(
    //     context, '/login');
  }

  Future<String?> getCurrentUserDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    } else {
      return user.displayName;
    }
  }

  Future<UserCredential> handleGoogleSignIn(
    // {
    //   required BuildContext context
    // }
  ) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(cred);

      String user = FirebaseAuth.instance.currentUser!.displayName.toString();
      FirebaseDatabase.instance.ref().child('users').child(user).set({"nama": user});

      // await Future.delayed(const Duration(seconds: 1));
      // Navigator.pushReplacementNamed(
      //   context, '/home');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

}
