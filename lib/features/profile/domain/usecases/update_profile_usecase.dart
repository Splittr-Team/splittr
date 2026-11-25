import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
final class UpdateProfileUseCase
    implements UseCase<Profile, UpdateProfileParams> {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      name: params.name,
      defaultCurrency: params.defaultCurrency,
    );
  }
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    this.name,
    this.defaultCurrency,
  });

  final String? name;
  final String? defaultCurrency;

  @override
  List<Object?> get props => [name, defaultCurrency];
}
