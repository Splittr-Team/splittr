import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
final class GetProfileUseCase implements UseCase<Profile, NoParams> {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Profile>> call(NoParams params) {
    return _repository.getProfile();
  }
}
