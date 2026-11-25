import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart';
import 'package:splittr/features/profile/domain/entities/profile.dart';
import 'package:splittr/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
final class UpdateAvatarUseCase
    implements UseCase<Profile, UpdateAvatarParams> {
  const UpdateAvatarUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Profile>> call(UpdateAvatarParams params) {
    return _repository.updateAvatar(params.file);
  }
}

class UpdateAvatarParams extends Equatable {
  const UpdateAvatarParams({required this.file});

  final File file;

  @override
  List<Object?> get props => [file.path];
}
