import 'package:app_resep_makanan/domain/usecases/auth/get_current_user_display_name.dart';
import 'package:app_resep_makanan/domain/usecases/auth/sign_in.dart';
import 'package:app_resep_makanan/domain/usecases/auth/sign_out.dart';
import 'package:app_resep_makanan/domain/usecases/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserDisplayNameUseCase _currentUserDisplayNameUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // AuthProvider() : _signInUseCase = SignInUseCase(AuthService());

  AuthProvider():
        _signInUseCase = SignInUseCase(AuthRepositoryImpl()),
        _signUpUseCase = SignUpUseCase(AuthRepositoryImpl()),
        _signOutUseCase = SignOutUseCase(AuthRepositoryImpl()),
        _currentUserDisplayNameUseCase = GetCurrentUserDisplayNameUseCase(AuthRepositoryImpl()){
  }

  Future<void> signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password
  }) async {
    try {
      // await _authService.signUp(name: name, email: email, password: password);

      await _signUpUseCase.call(name: name, email: email, password: password);

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
      // await _authService.signIn(email: email, password: password);
      await _signInUseCase.call(email: email, password: password);

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
      await _authRepository.handleGoogleSignIn();

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
    // await _authService.signOut();
    await _signOutUseCase.call();

    Navigator.pushReplacementNamed(
        context, '/login');
  }

  Future<String?> getCurrentUserDisplayName() async {
    return await _currentUserDisplayNameUseCase.call();
  }
}