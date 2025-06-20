import 'package:app_resep_makanan/data/repositories/auth_repository_impl.dart';

class SignOutUseCase {
  final AuthRepositoryImpl _authRepository;

  SignOutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.signOut();
  }
}