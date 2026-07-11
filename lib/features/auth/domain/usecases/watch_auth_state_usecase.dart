import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class WatchAuthStateUseCase
    implements StreamOptionUseCase<User, NoParams> {
  const WatchAuthStateUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Stream<Option<User>> call(NoParams params) {
    return _authRepository.watchAuthState;
  }
}
