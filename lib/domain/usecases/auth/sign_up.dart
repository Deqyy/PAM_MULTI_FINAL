import 'package:app_resep_makanan/data/repositories/auth_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final AuthRepositoryImpl _authRepository;

  SignUpUseCase(this._authRepository);

  Future<void> call({
    required String name,
    required String email,
    required String password
  }) async {
    try {
      await _authRepository.signUp(name: name, email: email, password: password);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}