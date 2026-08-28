import 'package:json_annotation/json_annotation.dart';
import 'package:splittr/features/expenses/data/models/expense_model.dart';
import 'package:splittr/features/friends/data/models/friend_model.dart';
import 'package:splittr/features/groups/data/models/group_model.dart';

part 'sync_response_model.g.dart';

@JsonSerializable()
class SyncResponseModel {
  const SyncResponseModel({
    required this.friends,
    required this.groups,
    required this.expenses,
  });

  factory SyncResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseModelFromJson(json);

  final DomainSyncModel<FriendModel> friends;
  final DomainSyncModel<GroupModel> groups;
  final DomainSyncModel<ExpenseModel> expenses;
}

@JsonSerializable(genericArgumentFactories: true)
class DomainSyncModel<T> {
  const DomainSyncModel({
    required this.newVersion,
    required this.updated,
    required this.deletedIds,
    this.currentServerVersion,
  });

  factory DomainSyncModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$DomainSyncModelFromJson(json, fromJsonT);

  final int newVersion;
  final int? currentServerVersion;
  final List<T> updated;
  final List<String> deletedIds;
}
