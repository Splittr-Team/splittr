import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:splittr/features/groups/domain/entities/group_preview.dart';
import 'package:splittr/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
final class GetGroupPreviewUseCase
    implements UseCase<GroupPreview, GetGroupPreviewParams> {
  const GetGroupPreviewUseCase(this._groupsRepository);

  final GroupsRepository _groupsRepository;

  @override
  Future<Either<Failure, GroupPreview>> call(GetGroupPreviewParams params) {
    return _groupsRepository.getGroupPreview(inviteCode: params.inviteCode);
  }
}

class GetGroupPreviewParams extends Equatable {
  const GetGroupPreviewParams({required this.inviteCode});

  final String inviteCode;

  @override
  List<Object?> get props => [inviteCode];
}
