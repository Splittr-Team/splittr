import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/auth/domain/entities/user.dart';
import 'package:splittr/features/auth/domain/repositories/auth_repository.dart';

// TODO(SKY): add custom stream use case
@lazySingleton
final class GetAuthStateChangesUseCase
    implements StreamUseCase<Option<User>, NoParams> {
  const GetAuthStateChangesUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Stream<Either<Failure, Option<User>>> call(NoParams params) {
    return _authRepository.authStateChanges.map(Right.new);
  }
}
