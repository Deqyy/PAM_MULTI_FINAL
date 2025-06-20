import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  }) async {
    try {
      await _authService.signUp(name: name, email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/home');

    } on FirebaseAuthException catch (e) {
      String? message = e.message;
      Fluttertoast.showToast(
          msg: message.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0
      );
    }
    catch (e) {
      // Catch any other errors
    }
  }


  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;

    notifyListeners();
    try {
      await _authService.signIn(
        // context: context,
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 1));

      // print("hello");
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String? message = e.message;
      Fluttertoast.showToast(
          msg: message.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 14.0
      );
    } catch (e) {

    }
  }

  Future<void> handleGoogleSignIn({required BuildContext context}) async {
    try {
      await _authService.handleGoogleSignIn();

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(
          context, '/home');
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut({
    required BuildContext context
  }) async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(
        context, '/login');
  }
}