import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class UploadGroupIconUseCase
    implements UseCase<Group, UploadGroupIconParams> {
  const UploadGroupIconUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  FutureEitherFailure<Group> call(UploadGroupIconParams params) {
    return _groupsRepository.uploadGroupIcon(
      groupId: params.groupId,
      file: params.file,
    );
  }
}

class UploadGroupIconParams extends Equatable {
  const UploadGroupIconParams({
    required this.groupId,
    required this.file,
  });

  final String groupId;
  final File file;

  @override
  List<Object?> get props => [groupId, file.path];
}
