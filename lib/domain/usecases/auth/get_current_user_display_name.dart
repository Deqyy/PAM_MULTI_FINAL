import 'package:app_resep_makanan/data/repositories/auth_repository_impl.dart';

class GetCurrentUserDisplayNameUseCase {
  final AuthRepositoryImpl _authRepositoryImpl;

  GetCurrentUserDisplayNameUseCase(this._authRepositoryImpl);

  Future<String?> call() async {
    return await _authRepositoryImpl.getCurrentUserDisplayName();
  }
}