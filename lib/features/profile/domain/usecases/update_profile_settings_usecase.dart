import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/user_settings.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
final class UpdateProfileSettingsUseCase
    implements UseCase<UserSettings, UpdateProfileSettingsParams> {
  const UpdateProfileSettingsUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, UserSettings>> call(
    UpdateProfileSettingsParams params,
  ) {
    return _repository.updateProfileSettings(
      autoAcceptFriendRequests: params.autoAcceptFriendRequests,
    );
  }
}

class UpdateProfileSettingsParams extends Equatable {
  const UpdateProfileSettingsParams({
    this.autoAcceptFriendRequests,
  });

  final bool? autoAcceptFriendRequests;

  @override
  List<Object?> get props => [autoAcceptFriendRequests];
}
