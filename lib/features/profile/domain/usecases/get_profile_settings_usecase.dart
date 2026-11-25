import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
final class GetProfileSettingsUseCase
    implements UseCase<UserSettings, NoParams> {
  const GetProfileSettingsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserSettings>> call(NoParams params) {
    return _repository.getProfileSettings();
  }
}
