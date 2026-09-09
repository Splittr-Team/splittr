import 'package:injectable/injectable.dart';
import 'package:splittr/features/expenses/data/datasources/expenses_remote_data_source.dart';
import 'package:splittr/features/expenses/data/models/create_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/settle_expense_payload.dart';
import 'package:splittr/features/expenses/data/models/update_expense_payload.dart';
import 'package:splittr/features/friends/data/datasources/friends_remote_data_source.dart';
import 'package:splittr/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:splittr/features/sync/domain/models/outbox_action_types.dart';
import 'package:splittr/features/sync/domain/services/outbox_worker.dart';

@lazySingleton
final class SyncDispatchersRegistrar {
  const SyncDispatchersRegistrar(
    this._outboxWorker,
    this._expensesRemoteDataSource,
    this._groupsRemoteDataSource,
    this._friendsRemoteDataSource,
  );

  final OutboxWorker _outboxWorker;
  final ExpensesRemoteDataSource _expensesRemoteDataSource;
  final GroupsRemoteDataSource _groupsRemoteDataSource;
  final FriendsRemoteDataSource _friendsRemoteDataSource;

  /// Registers all feature action dispatchers with the [OutboxWorker].
  void registerAll() {
    _outboxWorker
      ..registerDispatcher(
        OutboxActionTypes.createExpense,
        (payload, idempotencyKey) async {
          final createPayload = CreateExpensePayload.fromJson(payload);
          final result = await _expensesRemoteDataSource.createExpense(
            createPayload,
          );
          return result.expense.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.updateExpense,
        (payload, idempotencyKey) async {
          final id = payload['id'] as String;
          final updatePayload = UpdateExpensePayload.fromJson(payload);
          final result = await _expensesRemoteDataSource.updateExpense(
            id,
            updatePayload,
          );
          return result.expense.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.deleteExpense,
        (payload, idempotencyKey) async {
          final id = payload['id'] as String;
          await _expensesRemoteDataSource.deleteExpense(id);
          return null;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.settleExpense,
        (payload, idempotencyKey) async {
          final settlePayload = SettleExpensePayload.fromJson(payload);
          final result = await _expensesRemoteDataSource.settleExpense(
            settlePayload,
          );
          return result.expense.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.createGroup,
        (payload, idempotencyKey) async {
          final result = await _groupsRemoteDataSource.createGroup(
            name: payload['name'] as String,
            description: payload['description'] as String,
            requireAdminApproval: payload['requireAdminApproval'] as bool?,
          );
          return result.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.updateGroup,
        (payload, idempotencyKey) async {
          final result = await _groupsRemoteDataSource.updateGroup(
            groupId: payload['groupId'] as String,
            name: payload['name'] as String?,
            description: payload['description'] as String?,
            requireAdminApproval: payload['requireAdminApproval'] as bool?,
          );
          return result.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.deleteGroup,
        (payload, idempotencyKey) async {
          final groupId = payload['groupId'] as String;
          await _groupsRemoteDataSource.deleteGroup(groupId: groupId);
          return null;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.addFriend,
        (payload, idempotencyKey) async {
          final result = await _friendsRemoteDataSource.addFriend(
            friendEmail: payload['friendEmail'] as String?,
            friendPhone: payload['friendPhone'] as String?,
          );
          return result.id;
        },
      )
      ..registerDispatcher(
        OutboxActionTypes.removeFriend,
        (payload, idempotencyKey) async {
          final friendId = payload['friendId'] as String;
          await _friendsRemoteDataSource.removeFriend(friendId);
          return null;
        },
      );
  }
}
