import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:sky_architecture/sky_architecture.dart' hide Group;
import 'package:sky_bloc/sky_bloc.dart';
import 'package:splittr/features/groups/domain/entities/group.dart';
import 'package:splittr/features/groups/domain/usecases/join_group_usecase.dart';

part 'join_group_cubit.freezed.dart';
part 'join_group_state.dart';

@injectable
final class JoinGroupCubit extends BaseCubit<JoinGroupState> {
  JoinGroupCubit(this._joinGroupUseCase)
    : super(const JoinGroupState.joinGroupInitial());

  final JoinGroupUseCase _joinGroupUseCase;

  @override
  void started({Map<String, dynamic>? args}) {}

  Future<void> joinGroup({required String inviteCode}) async {
    emit(const JoinGroupState.joinGroupLoading());

    final result = await _joinGroupUseCase.call(
      JoinGroupParams(inviteCode: inviteCode),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(JoinGroupState.joinGroupFailure(failure: failure)),
      (group) => emit(JoinGroupState.joinGroupSuccess(group: group)),
    );
  }

  // TODO(Chaitanya): Remove isLoading as required in BaseCubit
  @override
  bool get isLoading => state is JoinGroupLoading;
}
