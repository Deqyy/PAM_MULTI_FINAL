import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repositories/auth_repository_impl.dart';

class SignInUseCase {
  final AuthRepositoryImpl _authRepository;

  SignInUseCase(this._authRepository);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    try {
      await _authRepository.signIn(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}